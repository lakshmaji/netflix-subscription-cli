import { readFile } from 'fs/promises';
import { parse } from "./lcov"
import { diff } from "./comment"

async function main({ github, context, core }) {
	const token = core.getInput("github-token")
	const lcovFile = core.getInput("lcov-file") || "./coverage/lcov.main"
	const baseFile = core.getInput("lcov-base")

	const raw = await readFile(lcovFile, "utf-8").catch(err => null)
	if (!raw) {
		console.log(`No coverage report found at '${lcovFile}', exiting...`)
		return
	}

	const baseRaw = baseFile && await readFile(baseFile, "utf-8").catch(err => null)
	if (baseFile && !baseRaw) {
		console.log(`No coverage report found at '${baseFile}', ignoring...`)
	}

	const options = {
		repository: context.payload.repository.full_name,
		prefix: `${process.env.GITHUB_WORKSPACE}/`,
	}

	if (context.eventName === "pull_request") {
		options.commit = context.payload.pull_request.head.sha
		options.head = context.payload.pull_request.head.ref
		options.base = context.payload.pull_request.base.ref
	} else if (context.eventName === "push") {
		options.commit = context.payload.after
		options.head = context.ref
	}

	const lcov = await parse(raw)
	const baselcov = baseRaw && await parse(baseRaw)
	const body = diff(lcov, baselcov, options)

	if (context.eventName === "pull_request") {
		await github.rest.issues.createComment({
			repo: context.repo.repo,
			owner: context.repo.owner,
			issue_number: context.payload.pull_request.number,
			body: diff(lcov, baselcov, options),
		})
	} else if (context.eventName === "push") {
		await github.rest.repos.createCommitComment({
			repo: context.repo.repo,
			owner: context.repo.owner,
			commit_sha: options.commit,
			body: diff(lcov, baselcov, options),
		})
	}
}

export default main
