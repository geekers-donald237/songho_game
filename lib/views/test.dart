while(_board[currentComputerIndex] >= 2 && _board[currentComputerIndex] <= 4){
setState((){
scoreComputer = scoreComputer + _board[currentComputerIndex];
final player = AudioCache();
player.play('prise.mp3');
_board[currentComputerIndex]= 0;
});
await Future.delayed(const Duration(milliseconds: 1500));
currentComputerIndex--;
}