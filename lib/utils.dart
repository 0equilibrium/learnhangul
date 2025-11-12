import 'models.dart';

String buildPracticeTip(HangulCharacter character) {
  if (character.type == HangulCharacterType.consonant) {
    return '${character.symbol}을(를) ㅏ/ㅗ/ㅣ 등 쉬운 모음과 묶고, 받침 자리에서도 한 번 더 적어 보세요.';
  }
  return '${character.symbol} 소리를 길게 끌어 발음하며 입술과 혀 위치를 거울로 확인하고, ㄴ이나 ㅇ과 합쳐 새 음절을 만들어 보세요.';
}
