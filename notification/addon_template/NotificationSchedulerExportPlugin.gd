@tool
extends EditorPlugin

const PLUGIN_NODE_TYPE_NAME = "NotificationScheduler"
const PLUGIN_PARENT_NODE_TYPE = "Node"
const PLUGIN_NAME: String = "@pluginName@"
const PLUGIN_VERSION: String = "@pluginVersion@"
const RESULT_ACTIVITY_CLASS_PATH: String = "@resultClass@"
const RECEIVER_CLASS_PATH: String = "@receiverClass@"
const SERVICE_CLASS_PATH: String = "@serviceClass@"

var export_plugin: AndroidExportPlugin


func _enter_tree() -> void:
	add_custom_type(PLUGIN_NODE_TYPE_NAME, PLUGIN_PARENT_NODE_TYPE, preload("NotificationScheduler.gd"), preload("icon.png"))
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree() -> void:
	remove_custom_type(PLUGIN_NODE_TYPE_NAME)
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = PLUGIN_NAME


	func _supports_platform(platform: EditorExportPlatform) -> bool:
		if platform is EditorExportPlatformAndroid:
			return true
		return false


	func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if debug:
			return PackedStringArray(["%s/bin/debug/%s-%s-debug.aar" % [_plugin_name, _plugin_name, PLUGIN_VERSION]])
		else:
			return PackedStringArray(["%s/bin/release/%s-%s-release.aar" % [_plugin_name, _plugin_name, PLUGIN_VERSION]])


	func _get_name() -> String:
		return _plugin_name


	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray([
			"androidx.appcompat:appcompat:1.6.1"
		])


	func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		var __contents: String = ""

		__contents += "<activity\n"
		__contents += "\tandroid:name=\"%s\"\n" % RESULT_ACTIVITY_CLASS_PATH
		__contents += "\tandroid:theme=\"@style/Theme.AppCompat.NoActionBar\"\n"
		__contents += "\tandroid:excludeFromRecents=\"true\"\n"
		__contents += "\tandroid:launchMode=\"singleTask\"\n"
		__contents += "\tandroid:taskAffinity=\"\" />\n\n"

		__contents += "<receiver\n"
		__contents += "\tandroid:name=\"%s\"\n" % RECEIVER_CLASS_PATH
		__contents += "\tandroid:process=\":remote\" />\n\n"

		__contents += "<service android:name=\"%s\" />\n" % SERVICE_CLASS_PATH

		return __contents
