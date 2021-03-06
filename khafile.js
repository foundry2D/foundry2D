let project = new Project('found');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("found");
project.addDefine("zui_translate");
project.addParameter('found.trait');
project.addParameter("--macro keep('found.trait')");
project.addParameter('found.node');
project.addParameter("--macro keep('found.node')");
project.addParameter('--macro echo.Macros.add_data("object", "found.object.Object")');
// @TODO: Fix strict null safety issues by enabling this and fixing the compile issues
// project.addParameter('--macro nullSafety("found", Strict)');

// To enable debug code for nodes:
// project.addDefine("debug_nodes");

project.addLibrary('Libraries/foundsdk/hxmath');
project.addLibrary('Libraries/foundsdk/echo');
project.addLibrary('Libraries/foundsdk/zui');
resolve(project);