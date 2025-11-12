import 'package:flutter/material.dart';

const Color seedColor = Color(0xFFEF476F);
const Color accentColor = Color(0xFFFFC857);

class HangulSection {
  const HangulSection({
    required this.title,
    required this.description,
    required this.characters,
  });

  final String title;
  final String description;
  final List<HangulCharacter> characters;
}

enum HangulCharacterType { consonant, vowel }

class HangulCharacter {
  const HangulCharacter({
    required this.symbol,
    required this.name,
    required this.romanization,
    required this.description,
    required this.example,
    required this.type,
  });

  final String symbol;
  final String name;
  final String romanization;
  final String description;
  final String example;
  final HangulCharacterType type;
}

const List<String> consonantPracticeIdeas = [
  '모음 ㅏ/ㅗ/ㅣ와 빠르게 조합하며 음절 리듬을 만들어 보세요.',
  '받침 위치에서 소리가 어떻게 닫히는지 천천히 들어보세요.',
  '비슷한 영어 자음과 비교해 혀와 입술의 위치를 메모하세요.',
];

const List<HangulSection> consonantSections = [
  HangulSection(
    title: '기본 자음',
    description: '단어의 뼈대를 만드는 14개의 기본 자음입니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㄱ',
        name: '기역',
        romanization: 'g / k',
        description: '입천장 뒤쪽을 막았다가 소리를 순간적으로 터뜨리는 파열음.',
        example: '가방 (ga-bang, bag)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄴ',
        name: '니은',
        romanization: 'n',
        description: '혀끝이 윗 잇몸에 닿는 비음으로, 부드러운 코 소리가 난다.',
        example: '나무 (na-mu, tree)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄷ',
        name: '디귿',
        romanization: 'd / t',
        description: '치조 부분을 닫아 내는 파열음으로, 끝소리에서는 t에 가깝다.',
        example: '달 (dal, moon)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄹ',
        name: '리을',
        romanization: 'r / l',
        description: '혀끝이 빠르게 닿았다 떨어지는 설측음으로, 위치에 따라 r/l 사이 소리가 난다.',
        example: '라면 (ra-myeon, ramen)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅁ',
        name: '미음',
        romanization: 'm',
        description: '입술을 닫았다가 코로 공기가 빠져나오는 비음.',
        example: '물 (mul, water)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅂ',
        name: '비읍',
        romanization: 'b / p',
        description: '입술을 튕기듯 닫았다 여는 파열음으로 끝에서는 p처럼 들린다.',
        example: '바람 (ba-ram, wind)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅅ',
        name: '시옷',
        romanization: 's',
        description: '치아 사이로 공기를 내보내는 마찰음. ㅣ계열 모음 앞에서는 sh처럼 들린다.',
        example: '사과 (sa-gwa, apple)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅇ',
        name: '이응',
        romanization: 'ng / silent',
        description: '글자의 처음에서는 소리가 없고, 끝에서는 콧소리 ng로 발음된다.',
        example: '아침 (a-chim, morning)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅈ',
        name: '지읒',
        romanization: 'j',
        description: 'ㄷ과 ㅅ의 성질이 섞인 파찰음으로, 부드러운 j 소리가 난다.',
        example: '자전거 (ja-jeon-geo, bicycle)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅊ',
        name: '치읓',
        romanization: 'ch',
        description: '거센 숨이 섞인 파찰음으로, ㅈ보다 더 강하게 공기를 뿜어낸다.',
        example: '친구 (chin-gu, friend)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅋ',
        name: '키읔',
        romanization: 'k (aspirated)',
        description: '거센 숨을 섞어 내는 파열음으로, ㄱ보다 공기가 훨씬 많이 나온다.',
        example: '카메라 (ka-me-ra, camera)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅌ',
        name: '티읕',
        romanization: 't (aspirated)',
        description: 'ㄷ보다 강한 숨이 섞인 치조 파열음.',
        example: '토끼 (to-kki, rabbit)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅍ',
        name: '피읖',
        romanization: 'p (aspirated)',
        description: '입술을 벌리며 강하게 내는 파열음으로, ㄱ/ㄷ보다 훨씬 숨이 많다.',
        example: '포도 (po-do, grape)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅎ',
        name: '히읗',
        romanization: 'h',
        description: '성대를 크게 벌려 내는 마찰음으로, 뒤 자음의 소리를 거세게 만든다.',
        example: '하늘 (ha-neul, sky)',
        type: HangulCharacterType.consonant,
      ),
    ],
  ),
  HangulSection(
    title: '쌍자음',
    description: '성대를 긴장시켜 내는 된소리 자음으로, 짧고 단단하게 발음합니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㄲ',
        name: '쌍기역',
        romanization: 'kk',
        description: '목을 조여 단단하게 내는 무성 파열음. ㄱ보다 훨씬 힘이 실린다.',
        example: '까치 (kka-chi, magpie)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄸ',
        name: '쌍디귿',
        romanization: 'tt',
        description: '혀끝을 강하게 붙였다 떼는 된소리로, 숨소리 없이 빠르게 발음된다.',
        example: '떡 (tteok, rice cake)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅃ',
        name: '쌍비읍',
        romanization: 'pp',
        description: '입술을 단단히 붙여 짧게 터트리는 소리.',
        example: '빵 (ppang, bread)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅆ',
        name: '쌍시옷',
        romanization: 'ss',
        description: '치아 사이를 스치는 소리를 강하게 낸 형태로, 숨의 마찰이 더 뚜렷하다.',
        example: '쌀 (ssal, rice grain)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅉ',
        name: '쌍지읒',
        romanization: 'jj',
        description: '입안에 압력을 채웠다가 순간적으로 터트리는 된소리 파찰음.',
        example: '짜장 (jja-jang, black bean sauce)',
        type: HangulCharacterType.consonant,
      ),
    ],
  ),
  HangulSection(
    title: '겹받침 자음',
    description: '받침에서만 등장하는 자음 조합으로, 뒤에 오는 음절에 따라 소리가 달라집니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㄳ',
        name: 'ㄱ+ㅅ',
        romanization: 'gs',
        description: '대부분 ㄱ으로 발음되고 뒤에 모음이 오면 ㄱ과 ㅅ이 나뉜다.',
        example: '값 (gap, price)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄵ',
        name: 'ㄴ+ㅈ',
        romanization: 'nj',
        description: '뒤에 모음이 없으면 ㄴ, 모음이 오면 ㄴ/ㅈ이 분리되어 발음된다.',
        example: '앉다 (an-da, sit)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄶ',
        name: 'ㄴ+ㅎ',
        romanization: 'nh',
        description: '겹받침이지만 대부분 ㄴ으로 발음되고 뒤 자음을 거세게 만든다.',
        example: '많다 (man-ta, many)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄺ',
        name: 'ㄹ+ㄱ',
        romanization: 'lg',
        description: '뒤에 모음이 없으면 ㄱ, 모음이 오면 ㄹ과 ㄱ이 나뉜다.',
        example: '읽다 (ik-tta, read)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄻ',
        name: 'ㄹ+ㅁ',
        romanization: 'lm',
        description: '대부분 ㅁ으로 발음되고 모음이 따라오면 ㄹ/ㅁ이 분리된다.',
        example: '삶 (sam, life)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄼ',
        name: 'ㄹ+ㅂ',
        romanization: 'lb',
        description: '받침에서는 보통 ㄹ, 모음 앞에서는 ㄹㅂ으로 나뉜다.',
        example: '밟다 (bap-tta, step on)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄽ',
        name: 'ㄹ+ㅅ',
        romanization: 'ls',
        description: '대부분 ㄹ로 발음되지만 뒤에 모음이 오면 ㄹ과 ㅅ이 각각 소리난다.',
        example: '곬 (gol, passage)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄾ',
        name: 'ㄹ+ㅌ',
        romanization: 'lt',
        description: '모음이 없으면 ㅌ, 모음이 따라오면 ㄹ과 ㅌ으로 나뉜다.',
        example: '훑다 (hut-tta, scan)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄿ',
        name: 'ㄹ+ㅍ',
        romanization: 'lp',
        description: '받침에서는 ㅍ으로, 모음 앞에서는 ㄹㅍ으로 분리되어 발음된다.',
        example: '읊다 (eup-tta, recite)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅀ',
        name: 'ㄹ+ㅎ',
        romanization: 'lh',
        description: '대부분 ㄹ로 발음되며 뒤 자음을 거세게 만드는 역할을 한다.',
        example: '싫다 (sil-ta, dislike)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅄ',
        name: 'ㅂ+ㅅ',
        romanization: 'bs',
        description: '받침에서는 주로 ㅂ으로 나고 뒤에 모음이 오면 ㅂ과 ㅅ이 각자 발음된다.',
        example: '값어치 (gap-eo-chi, value)',
        type: HangulCharacterType.consonant,
      ),
    ],
  ),
];

const List<HangulSection> vowelSections = [
  HangulSection(
    title: '기본 모음',
    description: '가장 기본적인 6개의 모음입니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㅏ',
        name: '아',
        romanization: 'a',
        description: '입을 크게 벌리고 입술을 편안히 둔 밝은 소리.',
        example: '바다 (ba-da, sea)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅓ',
        name: '어',
        romanization: 'eo',
        description: '입을 살짝 벌리고 혀를 뒤로 당겨 내는 중모음.',
        example: '서울 (seo-ul, Seoul)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅗ',
        name: '오',
        romanization: 'o',
        description: '입술을 둥글게 오므리되 턱은 많이 내리지 않는 소리.',
        example: '고모 (go-mo, aunt)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅜ',
        name: '우',
        romanization: 'u',
        description: '입술을 더 단단히 모으고 혀를 뒤로 당기는 소리.',
        example: '우산 (u-san, umbrella)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅡ',
        name: '으',
        romanization: 'eu',
        description: '입술을 양옆으로 당기고 혀를 평평하게 두는 중설 모음.',
        example: '그늘 (geu-neul, shade)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅣ',
        name: '이',
        romanization: 'i',
        description: '혀를 최대한 앞쪽으로 보내고 입술을 옆으로 당겨 내는 고모음.',
        example: '미소 (mi-so, smile)',
        type: HangulCharacterType.vowel,
      ),
    ],
  ),
  HangulSection(
    title: '이중 모음',
    description: '두 개의 모음이 결합된 모음입니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㅐ',
        name: '애',
        romanization: 'ae',
        description: 'ㅏ와 ㅣ가 만나 입이 점점 좁아지는 중저 모음.',
        example: '배 (bae, pear/boat)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅔ',
        name: '에',
        romanization: 'e',
        description: '혀가 중간 위치에 머무르며, 입은 ㅐ보다 조금 덜 벌어진다.',
        example: '네 (ne, you)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅚ',
        name: '외',
        romanization: 'oe',
        description: 'ㅗ에서 ㅣ로 미끄러져 입술이 둥글게 모였다가 옆으로 풀린다.',
        example: '외국 (oe-guk, foreign country)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅟ',
        name: '위',
        romanization: 'wi',
        description: '입술을 모았다가 ㅣ처럼 옆으로 벌리며 끝나는 소리.',
        example: '위험 (wi-heom, danger)',
        type: HangulCharacterType.vowel,
      ),
    ],
  ),
  HangulSection(
    title: '반모음',
    description: 'ㅣ나 ㅡ 앞에 ㅇ 소리가 붙은 모음입니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㅑ',
        name: '야',
        romanization: 'ya',
        description: 'ㅏ 발음 앞에 가벼운 ㅇ 발음을 붙여 내는 미끄러지는 소리.',
        example: '야구 (ya-gu, baseball)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅕ',
        name: '여',
        romanization: 'yeo',
        description: 'ㅓ 앞에 가벼운 ㅇ 소리를 얹어 부드럽게 미끄러진다.',
        example: '여우 (yeo-u, fox)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅛ',
        name: '요',
        romanization: 'yo',
        description: 'ㅗ에서 시작해 가볍게 미끄러지는 반모음이 결합된 발음.',
        example: '요리 (yo-ri, cooking)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅠ',
        name: '유',
        romanization: 'yu',
        description: 'ㅜ 앞에 가벼운 ㅇ 소리가 붙어 부드럽게 시작된다.',
        example: '유리 (yu-ri, glass)',
        type: HangulCharacterType.vowel,
      ),
    ],
  ),
  HangulSection(
    title: '복합 모음',
    description: '세 개 이상의 모음이 결합된 복합 모음입니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㅘ',
        name: '와',
        romanization: 'wa',
        description: 'ㅗ에서 시작해 ㅏ로 빠르게 이동하며 입술이 벌어진다.',
        example: '과일 (gwa-il, fruit)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅙ',
        name: '왜',
        romanization: 'wae',
        description: 'ㅗ+ㅐ 조합으로 입을 둥글게 했다가 조금 벌리며 끝난다.',
        example: '왜 (wae, why)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅝ',
        name: '워',
        romanization: 'wo',
        description: 'ㅜ에서 ㅓ로 이동하며 턱이 더 내려가고 입술이 느슨해진다.',
        example: '원 (won, origin/currency)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅞ',
        name: '웨',
        romanization: 'we',
        description: 'ㅜ+ㅔ 조합으로, 둥근 입 모양에서 평평한 입 모양으로 전환된다.',
        example: '웨딩 (we-ding, wedding)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅢ',
        name: '의',
        romanization: 'ui',
        description: 'ㅡ에서 ㅣ로 연결되는 모음으로, 소리의 중심을 앞으로 밀어낸다.',
        example: '의사 (ui-sa, doctor)',
        type: HangulCharacterType.vowel,
      ),
    ],
  ),
];
