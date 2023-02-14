extends Node

var Version = "0.0.1"

var UUID = null


func Firebase(url, Request : HTTPRequest, body, headers):
	var JsonObject = JSON.new()

	var error = await Request.request(url, headers, HTTPClient.METHOD_POST, body)
