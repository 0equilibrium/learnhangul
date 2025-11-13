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
    required this.example,
    required this.type,
  });

  final String symbol;
  final String name;
  final String romanization;
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
        example: '가방 (ga-bang, bag)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄴ',
        name: '니은',
        romanization: 'n',
        example: '나무 (na-mu, tree)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄷ',
        name: '디귿',
        romanization: 'd / t',
        example: '달 (dal, moon)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄹ',
        name: '리을',
        romanization: 'r / l',
        example: '라면 (ra-myeon, ramen)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅁ',
        name: '미음',
        romanization: 'm',
        example: '물 (mul, water)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅂ',
        name: '비읍',
        romanization: 'b / p',
        example: '바람 (ba-ram, wind)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅅ',
        name: '시옷',
        romanization: 's',
        example: '사과 (sa-gwa, apple)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅇ',
        name: '이응',
        romanization: 'ng / silent',
        example: '아침 (a-chim, morning)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅈ',
        name: '지읒',
        romanization: 'j',
        example: '자전거 (ja-jeon-geo, bicycle)',
        type: HangulCharacterType.consonant,
      ),
    ],
  ),
  HangulSection(
    title: '격음 자음',
    description: '강한 호흡으로 발음하는 격음 자음입니다.',
    characters: [
      HangulCharacter(
        symbol: 'ㅋ',
        name: '키읔',
        romanization: 'k',
        example: '카메라 (ka-me-ra, camera)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅌ',
        name: '티읕',
        romanization: 't',
        example: '토끼 (to-kki, rabbit)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅍ',
        name: '피읖',
        romanization: 'p',
        example: '포도 (po-do, grape)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅊ',
        name: '치읓',
        romanization: 'ch',
        example: '친구 (chin-gu, friend)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅎ',
        name: '히읗',
        romanization: 'h',
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
        example: '까치 (kka-chi, magpie)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄸ',
        name: '쌍디귿',
        romanization: 'tt',
        example: '떡 (tteok, rice cake)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅃ',
        name: '쌍비읍',
        romanization: 'pp',
        example: '빵 (ppang, bread)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅆ',
        name: '쌍시옷',
        romanization: 'ss',
        example: '쌀 (ssal, rice grain)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅉ',
        name: '쌍지읒',
        romanization: 'jj',
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
        example: '값 (gap, price)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄵ',
        name: 'ㄴ+ㅈ',
        romanization: 'nj',
        example: '앉다 (an-da, sit)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄶ',
        name: 'ㄴ+ㅎ',
        romanization: 'nh',
        example: '많다 (man-ta, many)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄺ',
        name: 'ㄹ+ㄱ',
        romanization: 'lg',
        example: '읽다 (ik-tta, read)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄻ',
        name: 'ㄹ+ㅁ',
        romanization: 'lm',
        example: '삶 (sam, life)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄼ',
        name: 'ㄹ+ㅂ',
        romanization: 'lb',
        example: '밟다 (bap-tta, step on)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄽ',
        name: 'ㄹ+ㅅ',
        romanization: 'ls',
        example: '곬 (gol, passage)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄾ',
        name: 'ㄹ+ㅌ',
        romanization: 'lt',
        example: '훑다 (hut-tta, scan)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㄿ',
        name: 'ㄹ+ㅍ',
        romanization: 'lp',
        example: '읊다 (eup-tta, recite)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅀ',
        name: 'ㄹ+ㅎ',
        romanization: 'lh',
        example: '싫다 (sil-ta, dislike)',
        type: HangulCharacterType.consonant,
      ),
      HangulCharacter(
        symbol: 'ㅄ',
        name: 'ㅂ+ㅅ',
        romanization: 'bs',
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
        example: '바다 (ba-da, sea)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅓ',
        name: '어',
        romanization: 'eo',
        example: '서울 (seo-ul, Seoul)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅗ',
        name: '오',
        romanization: 'o',
        example: '고모 (go-mo, aunt)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅜ',
        name: '우',
        romanization: 'u',
        example: '우산 (u-san, umbrella)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅡ',
        name: '으',
        romanization: 'eu',
        example: '그늘 (geu-neul, shade)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅣ',
        name: '이',
        romanization: 'i',
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
        example: '배 (bae, pear/boat)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅔ',
        name: '에',
        romanization: 'e',
        example: '네 (ne, you)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅚ',
        name: '외',
        romanization: 'oe',
        example: '외국 (oe-guk, foreign country)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅟ',
        name: '위',
        romanization: 'wi',
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
        example: '야구 (ya-gu, baseball)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅕ',
        name: '여',
        romanization: 'yeo',
        example: '여우 (yeo-u, fox)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅛ',
        name: '요',
        romanization: 'yo',
        example: '요리 (yo-ri, cooking)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅠ',
        name: '유',
        romanization: 'yu',
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
        example: '과일 (gwa-il, fruit)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅙ',
        name: '왜',
        romanization: 'wae',
        example: '왜 (wae, why)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅝ',
        name: '워',
        romanization: 'wo',
        example: '원 (won, origin/currency)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅞ',
        name: '웨',
        romanization: 'we',
        example: '웨딩 (we-ding, wedding)',
        type: HangulCharacterType.vowel,
      ),
      HangulCharacter(
        symbol: 'ㅢ',
        name: '의',
        romanization: 'ui',
        example: '의사 (ui-sa, doctor)',
        type: HangulCharacterType.vowel,
      ),
    ],
  ),
];
