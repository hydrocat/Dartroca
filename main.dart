import "dart:core";
import "dart:io";
import "dart:async";
import 'package:validator/validator.dart';
import 'dart:convert';
import "package:console/console.dart";
import "package:http/http.dart" as http;
/*
   Passos:
   - Le os parametros
 * parametros: 
 -> Maximo de letras da palavra
 -> Quantidade de Palavras
 -> Assunto

 - Busca a pagina do wikipedia
 * preprocessa
 -> tirando conectivos como "e" "com" "portanto"
 -> retorna uma Lista de String

 - Inicia o jogo
 * Escreve os espacos das palavras na tela
 * Escreve as Letras disponiveis para serem usadas
 * Desenha a tela

 - Loop do jogo 
 * Le uma letra do teclado 
 * Escreve as ocorrencias ( Desenha a tela de novo )
 * Quando todas as palavras estiverem escritas, termina o jogo
 */
final Map<String,String> errors = {
	"usage":"dart Dartroca.dart <qtd Palavras> <qtd Letras> <Assunto das Palavras>",
	"missingArgs":"faltam argumentos",
};

Map gameParam = new Map();

int main( List<String> arguments ) async  {

	//inicia a biblioteca console
	Console.init();
	// Le os parametros
	parseArgs(arguments);
	// Busca a pagina do wikipedia
	await searchWiki();
	// Inicia o jogo
	startGame();
	// Loop do jogo 
	gameLoop();

	return 0;
}
void normalize(String s){
	s = s.toUpperCase();
	s = s.replaceAll("Ã","A");
	s = s.replaceAll("Â","A");
	s = s.replaceAll("Õ","O");
	s = s.replaceAll("Ô","O");
	s = s.replaceAll("Ê","E");
	s = s.replaceAll("Î","I");
	s = s.replaceAll("Û","U");
	s = s.replaceAll("À","A");
	s = s.replaceAll("Á","A");
	s = s.replaceAll("È","E");
	s = s.replaceAll("É","E");
	s = s.replaceAll("Í","I");
	s = s.replaceAll("Ì","I");
	s = s.replaceAll("Ó","O");
	s = s.replaceAll("Ò","O");
	s = s.replaceAll("Ú","U");
	s = s.replaceAll("Ù","U");
	s = s.replaceAll("Ç","C");
	s = s.replaceAll(",", "");
	s = s.replaceAll(".", "");
	s = s.replaceAll("[", "");
	s = s.replaceAll("]", "");
	s = s.replaceAll("{", "");
	s = s.replaceAll("}", "");
	s = s.replaceAll("(", "");
	s = s.replaceAll(")", "");
	s = s.replaceAll("-", "");
	s = s.replaceAll("'", "");
	s = s.replaceAll('"', "");
	s = s.replaceAll(";", "");
	s = s.replaceAll("?", "");
	s = s.replaceAll("...", "");
	s = s.replaceAll("/", "");
	s = s.replaceAll(":", "");
	s = s.replaceAll("", "");
	s = stripLow(s, false);
	//s = s.split(" ");
	Set<String> words = new Set<String>.from( s.split(" ") );
	return new List.from(words);
}


parseArgs( List<String> args ) {

	try {
		gameParam["wordAmount"] = int.parse(args[0]);
		gameParam["letterAmount"] = int.parse(args[1]);
		gameParam["subject"] = args[2];
	} catch ( ex ){
		print( errors["usage"] );
		//print(ex);
		exit(1);
	}
}

searchWiki() async{
	//codigo que busca do wiki
	var url = 'http://pt.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&explaintext=&titles='+gameParam["subject"]+'&exsectionformat=plain';
	var rawText = await http.read(url);
	var jWord = JSON.decode(rawText); 

	gameParam["words"] = normalize(jWord.toString());
	//print( gameParam['words'] );

	//aqui, coloquei algumas palavras para testar
	//gameParam["words"]=["dart","linguagem","cart","gel","lingua","arte","tela","ela","mega"];
	//ordena as palavras em ordem crescente
	gameParam["words"].sort((b,a) => a.length.compareTo(b.length));
	//gameParam["wordAmount"] = gameParam["words"].length;
	//gameParam["letterAmount"] = "linguagem".length;
	//gameParam["subject"] = "Dart";

	await ChooseWord();
	//o codigo final deve colocar em "palavras" as palavras escolhidas e buscadas do wiki
	//utilize de gameParam para obter as informacoes nescessarias para esta parte do jogo,
	//como a quantidade de letras e o assunto (ou, pagina do wiki) que sera utilizada
}

void ChooseWord()
{
	//pega todas as palavras que têm o tamanho correto
	List newWords = new List<String>();
	gameParam['words'].forEach( (w){
		if ((w.length <= gameParam["letterAmount"]) && (w.length > 2)){
			newWords.add(w);
		}
	});
	//modificar isso aqui
	//gameParam['words'] = newWords;

	//extrai as letras de uma palavra (primeira) e conta quantas tem
	var characters = [];
	var count = [];
	for(var i in newWords[0].codeUnits)	{
		var index = characters.indexOf(i);
		if (index == -1){
			characters.add(i);
			count.add(1);
		}
		else{
			count[index]++;
		}
	}
	/////////////////////////
	//cria um mapa com as letras e quantidade de letras
	var m = new Map();
	m["char"] = [];
	m["count"] = [];
	m["word"] = [];
	m["char"].add(characters);
	m["count"].add(count);
	m["word"].add(newWords[0]);
	//percorre a lista de palavras
	for (var i = 1; i<newWords.length; i++) {
		var charaux = [];
		var countaux = [];
		//percorre a palavra selecionada
		for (var j in newWords[i].codeUnits){
			var index = m["word"][0].codeUnits.indexOf(j);
			var indexaux = charaux.indexOf(j);
			//se nao encontrou a letra na primeira palavra ja finaliza
			if (index == -1){
				charaux = [];
				countaux = [];
				break;
			}
			//senao ele cria a nova letra ou soma no indice
			else if (indexaux == -1){
				charaux.add(j);	
				countaux.add(1);

			}
			else {
				countaux[indexaux]++;
			}	

		}
		//se há alguma palavra entao verifica se a quantidade de letras é suficiente
		if (charaux.length != 0){
			var verif = true;
			//percorre a palavra
			for(var k = 0; k< charaux.length; k++){
				var index = m["char"][0].indexOf(charaux[k]);
				if (countaux[k] > m["count"][0][index])
				{
					verif = false;
				}

			}
			if (verif)
			{
				m["char"].add(charaux);
				m["count"].add(countaux);
				m["word"].add(newWords[i]);
			}
		}

	}
	gameParam["words"].clear();

	if (gameParam["wordAmount"] < m["word"].length){	
		m["word"] = m["word"].getRange(0,gameParam["wordAmount"]);
		m["char"] = m["char"].getRange(0,gameParam["wordAmount"]);
	}
//	print(m["char"]);

	gameParam["words"] = m["word"];
	gameParam['characters'] = new List<String>.from(m["word"])[0].split('');
	
	
}

// Inicia o jogo
startGame(){
	gameParam['visibleWords'] = new List<String>();
	gameParam["words"].forEach( (w){
		gameParam['visibleWords'].add( '_' * w.length );
	});

	gameParam['prompt'] = new Prompter('Digite uma letra: ');
	gameParam['usedLetters'] = new Set<String>();
	gameParam['end'] = 'P';
	draw();
}

// Desenha a tela 
draw() {
	gameParam['characters'].shuffle();
	Console.eraseDisplay(1);
	Console.moveCursor();
	Console.moveCursorDown();
	gameParam['visibleWords'].forEach( (w){
		print(' $w');
		print('');
	});
	print( gameParam['characters'] );
}

// Loop do jogo 
gameLoop(){
	while( gameParam['end'] == 'P' ){
		input();	
		process();	
		checkEndGame();
		print( gameParam['end'] );
		draw();
	}

	endGame();
}

void endGame(){
	TextPen pen = new TextPen();

	if (gameParam['end'] == "W"){
		pen.gold().text("Voce Ganhou !");
	} else {
		pen.red().text("Voce Desistiu !");
		print("As palavras sao: ");
		print( gameParam["words"] );
	}

	Console.centerCursor();
	pen.print();
	Console.moveCursorDown( gameParam['wordAmount'] +2 );
	new Prompter('').promptSync();
	
}

void input(){
	gameParam['input'] = gameParam['prompt'].promptSync();
}

void process(){
	int index = 0;
	gameParam['words'].forEach( (w) {
		if( w == gameParam['input'] ){
			gameParam['visibleWords'][index] = w;
		}

		index++;
	});
}

void checkEndGame(){
	if (gameParam['input'] == "DESISTO")
	{
		gameParam['end'] = "L";
	}
	else if (gameParam['visibleWords'].every((w) {return !w.contains('_');})) { 
		gameParam['end'] = "W";
	}
}

//Oh meu deus.. que monstruosidade eh essa ?!
String changeString( String realWord, String visibleWord, String letter ){
	String newWord = '';
	for ( num i = 0; i<realWord.length ; i++){
		if( visibleWord[i] == '_' ){
			if( realWord[i] == letter ){
				newWord += letter;
			} else {
				newWord += '_';
			}
		} else {
			newWord += visibleWord[i];
		}
	}
	return newWord;
}
