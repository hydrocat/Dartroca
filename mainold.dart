import 'dart:io'; // file

void main(List<String> arguments){
	//lança uma exception em modo de checagem
	assert(arguments.length == 1);

	
	File f;
	//verifica parametros e abre o arquivo
	try{
		arguments.length != 1 ? throw new Exception("Quantidade de argumentos inválidos\nDigite apenas o caminho do arquivo de palavras") : f = new File(arguments[0].toString());
	}
	catch (e){
		print("$e");
		return null;
		}
	

	var palavras = ["daniel", "iel", "ad", "lei", "da", "pastel", "alei", "coisa", "ave", "ovo", "lilili"]; //prototipo ----- apagar



}
