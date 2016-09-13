import 'dart:io';
import 'dart:async';
import 'dart:convert';
void main()
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
