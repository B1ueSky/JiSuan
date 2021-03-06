# JiSuan
> A Simple && Light-weight **inline** text calculator, which realeases your hands.  
> 妈咪问，挖掘机技术哪家强？  
> 爸爸说，中国山东找蓝翔！  

### OS Requirement:  
  - [x] Mac OS
  - [ ] Windows
  - [ ] Linus
  - [ ] Others

### Installation
```
  1. Clone to your Mac  
  2. Run the JiSuan project in Xcode
  3. (optional)
     Open System Preference -> Keyboard -> Shortcuts  
     -> Services -> add shortcut for JiSuan  
```

### How To
```
  1. Select any mathematical expression which conforms to the rules  
  2. Right-click -> Services -> JiSuan  
     or type the shortcut you define for JiSuan (recommanded)
     (note: the shorcut should be globally unique, e.g. ctrl+cmd+J)
```
### Example
|Selected text | output|
|:--------------:|:----------------:|
|3 * 4 + 5   | 3 * 4 + 5 = 17|
|log(3*5+1, 4) | log(3*5+1, 4) = 2|

### Rules
```
  All selected expressions should conform to the following rules,  
  or it may lead to unexpected result.
```
|Operation|Math Forumla|Priority|
|:--------------:|:----------------:|:-:|
|Parenthesis|(a)|1|
|Functions|f()|1|
|Factorial|a!|2|
|Pow|base^exponent|3|
|Negate|-a|4|
|Multiply|a * b|5|
|Divide|a / b|5|
|Modulo|a % b|5|
|Add|a + b|6|
|Subtract|a - b|6|

### Functions
|Function|Math Formula|
|:--------------:|:----------------:|
|2nd Root|sqrt(a)|
|nth Root|rt(a, n)|
|Absolute|abs(a)|
|Max|max(a, b)|
|Min|min(a, b)|
|Ceil|ceil(a)|
|Floor|floor(a)|
|Round|round(a)|
|Log|log(a, base)|
|Sine|sin(a)|
|Inverse Sine|asin(a)|
|Cosine|cos(a)|
|Inverse Cosine|acos(a)|
|Tangent|tan(a)|
|Inverse Tangent|atan(a)|

### Future extensions
```
  1. support variables in mathematical expressions
  2. show calculation steps
  3. add more operations
```

### Developers
@Shadowyyyy   (Ruan, Zhen-jie)  
@B1ueSky      (Luo, Tian-you)

###At last, thanks for all your STARs!
```
If you find any bug or have any suggestion, let us know.
```
