import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

main() async {
	 // print(await http.read("http://www.google.com/"));
	var gamaeParam = new Map()["subject"] = "urso";
	  var url = 'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&explaintext=&titles='gameParam["subject"]'&exsectionformat=plain'
		          var rawText = await http.read("https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&explaintext=&titles=life&exsectionformat=plain");
	  rawText = rawText.toUpperCase();
	var jWords = JSON.decode(rawText);
}
/*void main()
{
/*	File f = new File('api.php').readAsString().then((String content){
	//print(content);
		try{
	var a = JSON.encode(content);
		print(a[0]);
		}
		catch (e)
		{
			print(e);
		}
	});*/

	var fruits = ["grape", "passionfruit", "banana", "mango","orange", "raspberry", "apple", "blueberry"];
	fruits.sort((a,b) => b.length.compareTo(a.length));
	var l = [];
	for (var i in fruits[0].codeUnits)
	{
		print(i);
	}
	fruits.forEach((g) {l.add(g.codeUnits);});
	Map m = new Map();
	m["teste"] = l;
	print(m["teste"][0].indexOf(97));
}
