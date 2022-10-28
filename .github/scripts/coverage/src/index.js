import { promises as fs } from "fs"
import core from "@actions/core"
import path from "path"

import { parse } from "./lcov"
import { diff } from "./comment"
import { getChangedFiles } from "./get_changes"
import { deleteOldComments } from "./delete_old_comments"
import { normalisePath } from "./util"

const MAX_COMMENT_CHARS = 65536

async function main({ github, context, core }) {
	// const token = core.getInput("github-token")
	const workingDir = "./";
	const lcovFile = path.join(workingDir, "coverage/lcov/ruby-cli-genesis.lcov")
	// const baseFile = core.getInput("lcov-base")
	const baseFile = path.join(workingDir, "coverage/lcov.main")
	// const shouldFilterChangedFiles = core.getInput("filter-changed-files").toLowerCase() === "true"
	const shouldFilterChangedFiles = true
	const shouldDeleteOldComments =
		core.getInput("delete-old-comments").toLowerCase() === "true"
	// const title = core.getInput("title")
	const title = "Coverage report"

	const raw = await fs.readFile(lcovFile, "utf-8").catch(err => null)
	if (!raw) {
		console.log(`No coverage report found at '${lcovFile}', exiting...`)
		return
	}

	const baseRaw =
		baseFile && (await fs.readFile(baseFile, "utf-8").catch(err => null))
	if (baseFile && !baseRaw) {
		console.log(`No coverage report found at '${baseFile}', ignoring...`)
	}

	const options = {
		repository: context.payload.repository.full_name,
		prefix: normalisePath(`${process.env.GITHUB_WORKSPACE}/`),
		workingDir,
	}

	if (context.eventName === "pull_request") {
		options.commit = context.payload.pull_request.head.sha
		options.baseCommit = context.payload.pull_request.base.sha
		options.head = context.payload.pull_request.head.ref
		options.base = context.payload.pull_request.base.ref
	} else if (context.eventName === "push") {
		options.commit = context.payload.after
		options.baseCommit = context.payload.before
		options.head = context.ref
	}

	options.shouldFilterChangedFiles = shouldFilterChangedFiles
	options.title = title

	if (shouldFilterChangedFiles) {
		options.changedFiles = await getChangedFiles(github, options, context)
	}

	const lcov = await parse(raw)
	const baselcov = baseRaw && (await parse(baseRaw))
	const body = diff(lcov, baselcov, options).substring(0, MAX_COMMENT_CHARS)

	if (shouldDeleteOldComments) {
		await deleteOldComments(github, options, context)
	}

	if (context.eventName === "pull_request") {
		await github.rest.issues.createComment({
			repo: context.repo.repo,
			owner: context.repo.owner,
			issue_number: context.payload.pull_request.number,
			body: body,
		})
	} else if (context.eventName === "push") {
		await github.rest.repos.createCommitComment({
			repo: context.repo.repo,
			owner: context.repo.owner,
			commit_sha: options.commit,
			body: body,
		})
	}
}

export default main