import 'dart:math';

int problem1(_) {
  int counter = 0;
  for (int i = 3; i < 1000; ++i) {
    if (i % 3 == 0 || i % 5 == 0) counter += i;
  }
  return counter;
}

int problem2(_) {
  int counter = 0;
  int lastNum = 1;
  int currNum = 2;
  while (currNum < 4000000) {
    if (currNum % 2 == 0) counter += currNum;
    int oldCurr = currNum;
    currNum += lastNum;
    lastNum = oldCurr;
  }
  return counter;
}

BigInt problem3(_) {
  BigInt num = BigInt.parse("600851475143");
  for (BigInt i = BigInt.two; i < num + BigInt.one; i = i + BigInt.one) {
    if (num == i) return i;
    if (num % i == BigInt.zero && isPrime(i)) {
      num = num ~/ i;
      i = BigInt.two;
    }
  }
  return BigInt.one;
}

bool isPrime(BigInt num) {
  if (num < BigInt.two) return false;
  if (num < BigInt.from(4)) return true;
  for (BigInt i = BigInt.two; i < num; i += BigInt.one) {
    if (num % i == BigInt.zero) return false;
  }
  return true;
}

bool isIntPrime(int num) {
  if (num < 2) return false;
  if (num < 4) return true;
  int loopBound = (sqrt(num) + 1).toInt();
  for (int i = 2; i < loopBound; ++i) {
    if (num % i == 0) return false;
  }
  return true;
}

int problem4(_) {
  int largestPalindrome = 0;
  for (int a = 100; a < 1000; ++a) {
    for (int b = a; b < 1000; ++b) {
      if (isPalindrome(a * b) && a * b > largestPalindrome)
        largestPalindrome = a * b;
    }
  }
  return largestPalindrome;
}

bool isPalindrome(int num) {
  final str = num.toString();
  for (int i = 0; i < str.length; ++i) {
    if (str[i] != str[str.length - 1 - i]) return false;
  }
  return true;
}

int factorial(int num) => (num < 2) ? 1 : num * factorial(num - 1);

int problem5(_) {
  bool isValid(int num) {
    for (int i = 1; i < 21; ++i) {
      if (num % i != 0) return false;
    }
    return true;
  }

  int answer = factorial(20);
  for (int i = 2; i < 21; ++i) {
    while (isValid(answer)) {
      if (answer % i == 0)
        answer ~/= i;
      else
        break;
    }
    answer *= i;
  }
  return answer;
}

BigInt problem6(_) {
  BigInt answer = BigInt.zero;
  for (int i = 1; i <= 100; ++i) answer += BigInt.from(i);
  answer = answer.pow(2);
  for (int i = 1; i <= 100; ++i) answer -= BigInt.from(i).pow(2);
  return answer;
}

BigInt problem7(_) {
  int counter = 0;
  for (BigInt i = BigInt.two; true; i += BigInt.one) {
    if (isPrime(i)) counter++;
    if (counter == 10001) return i;
  }
}

BigInt problem8(_) {
  final num = "73167176531330624919225119674426574742355349194934"
      "96983520312774506326239578318016984801869478851843"
      "85861560789112949495459501737958331952853208805511"
      "12540698747158523863050715693290963295227443043557"
      "66896648950445244523161731856403098711121722383113"
      "62229893423380308135336276614282806444486645238749"
      "30358907296290491560440772390713810515859307960866"
      "70172427121883998797908792274921901699720888093776"
      "65727333001053367881220235421809751254540594752243"
      "52584907711670556013604839586446706324415722155397"
      "53697817977846174064955149290862569321978468622482"
      "83972241375657056057490261407972968652414535100474"
      "82166370484403199890008895243450658541227588666881"
      "16427171479924442928230863465674813919123162824586"
      "17866458359124566529476545682848912883142607690042"
      "24219022671055626321111109370544217506941658960408"
      "07198403850962455444362981230987879927244284909188"
      "84580156166097919133875499200524063689912560717606"
      "05886116467109405077541002256983155200055935729725"
      "71636269561882670428252483600823257530420752963450";
  BigInt largestProduct = BigInt.zero;
  for (int i = 0; i <= num.length - 13; ++i) {
    BigInt currProduct = BigInt.one;
    var currStr = num.substring(i, i + 13);
    for (int i = 0; i < currStr.length; ++i) {
      currProduct *= BigInt.parse(currStr[i]);
    }
    if (currProduct > largestProduct) largestProduct = currProduct;
  }
  return largestProduct;
}

double problem9(_) {
  for (int a = 0; a < 500; ++a) {
    for (int b = a; b < 500; ++b) {
      var c = sqrt(b * b + a * a);
      if (c % 1 == 0.0 && a + b + c == 1000) return a * b * c;
    }
  }
  return 0;
}

int problem10(_) {
  int sum = 0;
  for (int i = 2; i < 2000000; ++i) if (isIntPrime(i)) sum += i;
  return sum;
}

int problem12(_) {
  for (int n = 2; true; ++n) {
    int currTriNum = n * (n + 1) ~/ 2;
    int numOfFactors = 1;
    for (int i = 2; i <= sqrt(currTriNum); ++i) {
      if (currTriNum % i == 0) numOfFactors++;
    }
    numOfFactors *= 2;
    if (sqrt(currTriNum) % 1 == 0) numOfFactors--;
    if (numOfFactors > 500) return currTriNum;
  }
}

int problem20(_) {
  BigInt num = BigInt.one;
  for (int i = 2; i <= 100; ++i) {
    num = num * BigInt.from(i);
  }
  final str = num.toString();
  int answer = 0;
  for (int i = 0; i < str.length; ++i) {
    answer += int.parse(str[i]);
  }
  return answer;
}

int problem40(_) {
  int product = 1;
  int index = 1;
  int currTenMultiple = 1;
  for (int i = 1; i < 100000; ++i) {
    var iStr = i.toString();
    if ((index <= currTenMultiple) && (currTenMultiple < index + iStr.length)) {
      product *= int.parse(iStr[currTenMultiple - index]);
      currTenMultiple *= 10;
    }
    index += iStr.length;
  }
  return product;
}

BigInt problem48(_) {
  var answer = BigInt.zero;
  for (var i = BigInt.one; i <= BigInt.from(1000); i += BigInt.one) {
    answer += i.modPow(i, BigInt.from(10).pow(10));
  }
  return answer % BigInt.from(10).pow(10);
}
