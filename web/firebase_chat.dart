import 'dart:html';
import 'dart:js';

InputElement messageInput;
InputElement nameInput;
DivElement div;
JsObject myDataRef;

main() {
  myDataRef = new JsObject(context['Firebase'], ['https://ihp8plr13um.firebaseio-demo.com/']); // Создаем JS объект с типом Firebase взятым из импортированной JS библиотеки
  messageInput = querySelector('#messageInput') as InputElement; //Линкуем элемент из HTML файла с Dart объектом
  nameInput = querySelector('#nameInput') as InputElement; //Линкуем элемент из HTML файла с Dart объектом 
  div = querySelector('#messagesDiv') as DivElement; //Линкуем элемент из HTML файла с Dart объектом 
  messageInput.onKeyPress.listen(onMessageInputKeyPress); //Вешаем обработчик на onKeyPress
   
  myDataRef.callMethod('on', ['child_added', // Вызываем JS функцию .on('child_added',
    //new JsFunction.withThis((jsThis, a, b) { // Делаем обертку в JS ф-цию для регистрации в качестве CallBack
    (a, b) {                          
      var message = a.callMethod('val',[]); // Вызываем JS функцию .val()
      print(message['name'] + ':' + message['text']);
      displayChatMessage(message['name'], message['text']);
    }
  ]);
}

void onMessageInputKeyPress(KeyboardEvent e){
  if (e.keyCode == 13) {
    var name = nameInput.value;
    var text = messageInput.value;
    var jsParams = new JsObject.jsify( {'name' : '$name', 'text' : '$text'}); // Заворачиваем параметры в JS объект
    myDataRef.callMethod( 'push', [jsParams]); // Вызываем JS функцию .push(
    messageInput.value ='';
  };
}

void displayChatMessage(String name, String text) {
  div.appendHtml('<em>$name:</em> $text<br />'); 
}
