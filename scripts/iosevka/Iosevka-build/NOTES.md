
## pnpm 兼容问题

这里优先采用 `<project-root>/.npmrc` `shamefully-hoist = true` 的方法，产生 flat node_modules 消除依赖找不到的问题。

另一种方法需要修改 `verdafile.mjs`

```js
const DependenciesFor = computed.make(
	pakcageJsonPath => `env::dependencies-for::${pakcageJsonPath}`,
	async (target, pakcageJsonPath) => {
		const [pjf] = await target.need(sfu(pakcageJsonPath));
		const pj = JSON.parse(await FS.promises.readFile(pjf.full, "utf-8"));
		let subGoals = [];
		for (const pkgName in pj.dependencies) {
			if (/^@iosevka/.test(pkgName)) continue;
			subGoals.push(InstalledVersion(pkgName, pj.dependencies[pkgName]));
		}
		const [actual] = await target.need(subGoals);
		return actual;
	},
);

const InstalledVersion = computed.make(
	(pkg, required) => `env::installed-version::${pkg}::${required}`,
	async (target, pkg, required) => {
		const [pj] = await target.need(sfu(`node_modules/${pkg}/package.json`));
		const depPkg = JSON.parse(await FS.promises.readFile(pj.full));
		if (!semver.satisfies(depPkg.version, required)) {
			fail(
				`Package version for ${pkg} is outdated:`,
				`Required ${required}, Installed ${depPkg.version}`,
			);
		}
		return { name: pkg, actual: depPkg.version, required };
	},
);
```

改为

```js
const DependenciesFor = computed.make(
	pakcageJsonPath => `env::dependencies-for::${pakcageJsonPath}`,
	async (target, pakcageJsonPath) => {
		const dir = Path.dirname(pakcageJsonPath);
		const [pjf] = await target.need(sfu(pakcageJsonPath));
		const pj = JSON.parse(await FS.promises.readFile(pjf.full, "utf-8"));
		let subGoals = [];
		for (const pkgName in pj.dependencies) {
			if (/^@iosevka/.test(pkgName)) continue;
			subGoals.push(InstalledVersion(dir, pkgName, pj.dependencies[pkgName]));
		}
		const [actual] = await target.need(subGoals);
		return actual;
	},
);

const InstalledVersion = computed.make(
	(root, pkg, required) => `env::installed-version::${pkg}::${required}`,
	async (target, root, pkg, required) => {
		const [pj] = await target.need(sfu(`${root}/node_modules/${pkg}/package.json`));
		const depPkg = JSON.parse(await FS.promises.readFile(pj.full));
		if (!semver.satisfies(depPkg.version, required)) {
			fail(
				`Package version for ${pkg} is outdated:`,
				`Required ${required}, Installed ${depPkg.version}`,
			);
		}
		return { name: pkg, actual: depPkg.version, required };
	},
);
```