const impl = require("./output/Murr.Core")

/**
 * @param {String} path Path of the project to inspect
 * @return {String[]} List of vulnerable packages detected
 */
const inspectProject = path => impl.inspectProject(path)();

/**
 * @param {String} pkgJson contents of a "package.json" file.
 * @returns {String[]} Array of vulnerable packages
 */
const inspectPackageJson = pkgJson => impl.inspectPackageJson(pkgJson)

module.exports = {
  inspectProject,
  inspectPackageJson
}
