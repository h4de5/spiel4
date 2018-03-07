extends Node

var requests = []

func _ready():
	requests = []
	
func send (url, query = '', data = '', callback = null, parent = null, callbackparams = []):
	
	var request = HTTPRequest.new()
	request.set_script(preload("res://game/autoloads/http.gd"))
	get_tree().get_root().add_child(request)
	
	request.send (url, query, data, callback, parent, callbackparams)
	requests.append(request)
	return request

func cancle(request):
	request.cancel()
	

# general request completion information
# use this func signature for callback methods
# call this func to get response
func on_request_completed(result, response_code, headers, body, params = []):
	#disconnect("request_completed", self, "_on_request_completed")
	if result == HTTPRequest.RESULT_SUCCESS and response_code == HTTPClient.RESPONSE_OK:

		# TODO: check for Content-Type: text/html; charset=UTF-8
		# to automatically convert from json and get_string from utf8

		#var dict = parse_json(body.get_string_from_ascii())

		# body is a PoolByteArray
		# body = body.get_string_from_ascii()
		body = body.get_string_from_utf8()

		#print("Request succeeded - body: ", body, " headers: ", headers)

		return {"headers": headers, "body": body, "params": params}
	else:
		printerr("Request failed - Code: ", result, " HTTP Status: ", response_code)
		return false