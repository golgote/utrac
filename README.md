Examples
========
On this page are some examples on how to use Utrac as a command line tool or as a library.

Command line tool
-----------------

### Automatic recognition

The simpliest way tu use utrac is by providing a filename as an argument (with no filename, utrac read the standard input):

```
~/dev/utrac> utrac gb_bit.txt
Venez, vous dont l'œil étincelle
Pour entendre une histoire encor
Approchez: je vous dirai celle
De dońa Padilla del Flor
Elle était d'Alanje, où s'entassent
Les collines et les halliers
Enfants, voici des bœufs qui passent
Cachez vos rouges tabliers
```

In this case, utrac read the file, analyse it to guess which charset fits best, and convert the text to the default charset (see the conversion section for more explainations).

If we just want to print the charset of the text, we can use the -p option:

```
~/dev/utrac> utrac -p gb_bit.txt
ISO-8859-15
```

Option -i permits to print more informations about the file :

```
~/dev/utrac> utrac -i gb_bit.txt
Filename: gb_bit.txt
Charset (unsure): ISO-8859-15
EOL: LF (8 lines)
Size: 251
```

We can remark that the charset recognition is unsure. Except if the result of the recognition is ASCII or UTF-8, utrac will never be sure, since a lot of charsets are very similar and choosing between them is a difficult task for a computer... in a few cases it can even be impossible! However, if you want a confirmation of the result, you can try the options explained at the "Manual recognition" section.

We can also ask utrac to print a list of all the charsets that are likely to fit, and how it rated them, rather than just printing the best one. This is done with the -P option:

```
  ~/dev/utrac> utrac gb_full.txt -P
  With locale   Brut   Checksum      Name(s)
       100       99    (811b75fe)    ISO-8859-15
       100       99    (9105eac2)    ISO-8859-16
        89       88    (18b48940)    ISO-8859-4
        89       88    (5f5bdd36)    ISO-8859-14
        83       83    (1e3e4b86)    MacCentralEuropean
        72       72    (811bf86f)    CP775
        71       67    (fdb25adc)    ISO-8859-1
        69       67    (fdb25adc)    CP1252
        68       67    (e5443fab)    ISO-8859-2
        68       67    (202b2ccc)    ISO-8859-13
        68       67    (2a4ef11d)    ISO-8859-10
        68       67    (fdb25adc)    ISO-8859-9, ISO-8859-3
        67       67    (e5443fab)    CP1250
        67       67    (fdb25adc)    CP1258, CP1254
        67       67    (202b2ccc)    CP1257
        66       66    (ffeb5fb3)    CP1256
        63       63    (4cdc9628)    CP852
        47       47    ( 9ab8f52)    MacCroatian
        43       42    (a357e5bc)    MacRoman
        42       42    (a357e5bc)    MacRomanian, MacTurkish
        39       39    (d8c58a25)    CP850
        34       34    (  ce4b54)    ISO-8859-11, CP874
        33       33    (a4872376)    CP857
        30       30    (6d46415a)    CP855
        28       28    (78b31505)    ISO-8859-5
        28       28    (fedbaa3a)    CP1253, ISO-8859-7
        28       28    (d12afbdc)    CP1251
        26       26    (2c4f7ba8)    CP866
        25       25    (43a0880f)    CP869
        24       24    ( ab387ea)    CP737
        11       11    ( c42f4d5)    CP437, CP860, CP861, CP862, CP863, CP865
         6        6    (f08930ed)    KOI8-U
         6        6    (a56cc2c5)    KOI8-R
         2        2    (73748f44)    CP864
         0        0    (2bf9fe2a)    ISO-8859-8, CP1255
       -22      -22    (f165535d)    ISO-8859-6
```

Hum... it seems that things are getting more complicated! Let me explain what is this array:

The first column is the	score of each charset (names are on the last column) with a bonus depending on the locale; this bonus will depend on the operating system and on the language.
The second column is the score without the bonus. It is computed internally (see the FAQ for more informations).
The third column is the checksum of all extended characters (i.e. those in range 128 to 255) after conversion. It permits to know which charset will give the same text after conversion.
The last column is the name of the charset. If two charsets are on the same line, it means that they have the same score with locale and the same checksum, for instance ISO-8859-9 and ISO-8859-3.
If the -P option is used and if the result of the recognition is unambigous (i.e. is either ASCII or UTF-8), only the result will be printed on one line.

To know which language and system are selected, and thus which charsets will get bonus, you can use the -d option:

```
  ~/dev/utrac> utrac -d
  Language: Default
  System: Unix
  Output charset: UTF-8
  Output EOL: LF
  Error character: '_'
```

Language depend on the LC_xxx, and system is set at compilation. It is also possible to set them with the -L and -S options:

```
  ~/dev/utrac> utrac -d -L DE -S none
  Language: German
  System: None
  Output charset: UTF-8
  Output EOL: LF
  Error character: '_'
```

You can get the list of language and sytem with the -l option. They are defined in the charsets.dat file, with all the charsets and their bonus. The bonus is usually a few percents added to the score (2%, 4%, 6%...). For instance if the sytem is a Unix, all the ISO-8858-xxwill get a bonus, CP125x on Windows... If French is selected, charsets ISO-8859-1 and 15, CP1252, MacRoman and CP850 will get a big bonus and ISO-8859-3, 9, 14 and 16, will have a little bonus.

Conversion
----------
With no options, conversion will be done from the recognized charset to the default charset. The default charset is specified at compilation or by the variables LC_CTYPE, LC_ALL or LANG.

It is possible to select input and output charsets with the -f and -t options. However, if an input charset is provided, then recognition will be disabled.

It is also possible to fix the end-of-line type with option -t (it doesn't work with -f now, but may be it will later) :

```
  ~/dev/utrac> utrac gb_bit.txt -t utf-8/lf
  ...
  ~/dev/utrac> utrac gb_bit.txt -t crlf
  ...
```

If some characters cannot be converted, for instance because they does not exist in the output charset, they will be replaced by an error character. By default, this is '_', and it currently cannot be changed.

Manual recognition
------------------
Since charset recognition is not always easy, and since utrac is not as smart as you, it provides some features that facilitates manual recognition. These features are intended to help choose a 8 bits ASCII-derivated charset, since UTF-8 is easilly recognized (and since utrac does not manage any other kind of charsets).

It is possible to filter the text and to print only the lines with extended characters with the -x option (and -c for a color output):

```
  ~/dev/utrac> utrac gb_full.txt -x -c
    0 [2]: Venez, vous dont l'œil étincelle
    3 [1]: De doña Padilla del Flor
    4 [2]: Elle était d'Alanje, où s'entassent
   27 [2]: Elle prit le voile à Tolède
   36 [3]: Or, la belle à peine cloîtrée
```

If same extended character appears on several lines, only one line will be printed. Also, the output charset can be selected with -t option, as for conversion.

It is also possible to print each extended character with each different charset with the -a option:

```
  ~/dev/utrac> utrac gb_full.txt -a
                | BD | E0 | E8 | E9 | EE | F1 | F9 |
     ISO-8859-1 |  ½ |  à |  è |  é |  î |  ñ |  ù |
     ISO-8859-2 |  ˝ |  ŕ |  č |  é |  î |  ń |  ů |
     ISO-8859-3 |  ½ |  à |  è |  é |  î |  ñ |  ù |
     ISO-8859-4 |  Ŋ |  ā |  č |  é |  î |  ņ |  ų |
     ISO-8859-5 |  Н |  р |  ш |  щ |  ю |  ё |  љ |
     ISO-8859-6 |  _ |  ـ |  و |  ى |  َ |  ّ |  _ |
     ISO-8859-7 |  ½ |  ΰ |  θ |  ι |  ξ |  ρ |  ω |
     ISO-8859-8 |  ½ |  א |  ט |  י |  מ |  ס |  ש |
     ISO-8859-9 |  ½ |  à |  è |  é |  î |  ñ |  ù |
    ISO-8859-10 |  ― |  ā |  č |  é |  î |  ņ |  ų |
    ISO-8859-11 |  ฝ |  เ |  ่ |  ้ |  ๎ |  ๑ |  ๙ |
    ISO-8859-13 |  ½ |  ą |  č |  é |  ī |  ń |  ł |
    ISO-8859-14 |  Ẅ |  à |  è |  é |  î |  ñ |  ù |
    ISO-8859-15 |  œ |  à |  è |  é |  î |  ñ |  ù |
    ISO-8859-16 |  œ |  à |  è |  é |  î |  ń |  ù |
  MacCentralEur |  Ĺ |  ŗ |  Ť |  ť |  Ó |  Ů |  ý |
    MacCroatian |  Ω |    |  č |  È |  Ó |  Ò |  π |
       MacRoman |  Ω |  ‡ |  Ë |  È |  Ó |  Ò |  ˘ |
    MacRomanian |  Ω |  ‡ |  Ë |  È |  Ó |  Ò |  ˘ |
     MacTurkish |  Ω |  ‡ |  Ë |  È |  Ó |  Ò |  ˘ |
          CP437 |    |  α |  Φ |  Θ |  ε |  ± |    |
          CP737 |    |  ω |  ϋ |  ώ |  Ό |  ± |    |
          CP775 |  Į |  Ó |  Ķ |  ķ |  Ņ |  ± |    |
          CP850 |  ¢ |  Ó |  Þ |  Ú |  ¯ |  ± |  ¨ |
          CP852 |  Ż |  Ó |  Ŕ |  Ú |  ţ |  ˝ |  ¨ |
          CP855 |  й |  Я |  У |  ж |  Ь |  ы |  щ |
          CP857 |  ¢ |  Ó |  × |  Ú |  ¯ |  ± |  ¨ |
          CP860 |    |  α |  Φ |  Θ |  ε |  ± |    |
          CP861 |    |  α |  Φ |  Θ |  ε |  ± |    |
          CP862 |    |  α |  Φ |  Θ |  ε |  ± |    |
          CP863 |    |  α |  Φ |  Θ |  ε |  ± |    |
          CP864 |  ﺵ |  ـ |  ﻭ |  ﻯ |  ﻍ |  ّ | ﻵ  |
          CP865 |    |  α |  Φ |  Θ |  ε |  ± |    |
          CP866 |    |  р |  ш |  щ |  ю |  ё |    |
          CP869 |  Ξ |  ζ |  ξ |  ο |  τ |  ± |  ¨ |
          CP874 |  ฝ |  เ |  ่ |  ้ |  ๎ |  ๑ |  ๙ |
         CP1250 |  ˝ |  ŕ |  č |  é |  î |  ń |  ů |
         CP1251 |  Ѕ |  а |  и |  й |  о |  с |  щ |
         CP1252 |  ½ |  à |  è |  é |  î |  ñ |  ù |
         CP1253 |  ½ |  ΰ |  θ |  ι |  ξ |  ρ |  ω |
         CP1254 |  ½ |  à |  è |  é |  î |  ñ |  ù |
         CP1255 |  ½ |  א |  ט |  י |  מ |  ס | ש |
         CP1256 |  ½ |  à |  è |  é |  î |  ٌ |  ù |
         CP1257 |  ½ |  ą |  č |  é |  ī |  ń |  ł |
         CP1258 |  ½ |  à |  è |  é |  î |  ñ |  ù |
         KOI8-U |    |  Ю |  Х |  И |  Н |  Я |  Ы |
         KOI8-R |    |  Ю |  Х |  И |  Н |  Я |  Ы |
```

Some lines are not well displayed because of specials characters like accents that required other characters to be printed. Also, it is strongly advised to use an UTF-8 terminal. You can for instance use an UTF-8 xterm with the command "xterm -en UTF-8".

Finally, the -z option displays the distribution of each character:

```
  ~/dev/utrac> utrac gb_full.txt -z
< 0-.>     <20+ > 312 <40-@>     <60-`>     <80-.>     <a0- >     <c0-À>     <e0+à>   5 
< 1-.>     <21+!>   1 <41+A>   9 <61+a> 144 <81-.>     <a1-¡>     <c1-Á>     <e1-á>     
< 2-.>     <22+">   2 <42-B>     <62+b>  33 <82-.>     <a2-¢>     <c2-Â>     <e2-â>     
< 3-.>     <23-#>     <43+C>  14 <63+c>  48 <83-.>     <a3-£>     <c3-Ã>     <e3-ã>     
< 4-.>     <24-$>     <44+D>   6 <64+d>  67 <84-.>     <a4-¤>     <c4-Ä>     <e4-ä>     
< 5-.>     <25-%>     <45+E>  14 <65+e> 229 <85-.>     <a5-¥>     <c5-Å>     <e5-å>     
< 6-.>     <26-&>     <46+F>   1 <66+f>  36 <86-.>     <a6-¦>     <c6-Æ>     <e6-æ>     
< 7-.>     <27+'>  17 <47+G>   1 <67+g>  20 <87-.>     <a7-§>     <c7-Ç>     <e7-ç>     
< 8-.>     <28-(>     <48-H>     <68+h>  20 <88-.>     <a8-¨>     <c8-È>     <e8+è>   3 
< 9-.>     <29-)>     <49+I>   5 <69+i> 124 <89-.>     <a9-©>     <c9-É>     <e9+é>  16 
< a+.>  80 <2a-*>     <4a-J>     <6a+j>   3 <8a-.>     <aa-ª>     <ca-Ê>     <ea-ê>     
< b-.>     <2b-+>     <4b-K>     <6b-k>     <8b-.>     <ab-«>     <cb-Ë>     <eb-ë>     
< c-.>     <2c+,>  19 <4c+L>  11 <6c+l> 114 <8c-.>     <ac-¬>     <cc-Ì>     <ec-ì>     
< d-.>     <2d+->   1 <4d+M>   2 <6d+m>  17 <8d-.>     <ad-­>     <cd-Í>     <ed-í>     
< e-.>     <2e-.>     <4e-N>     <6e+n> 122 <8e-.>     <ae-®>     <ce-Î>     <ee+î>   1 
< f-.>     <2f-/>     <4f+O>   4 <6f+o>  93 <8f-.>     <af-¯>     <cf-Ï>     <ef-ï>     
<10-.>     <30-0>     <50+P>   4 <70+p>  43 <90-.>     <b0-°>     <d0-Ð>     <f0-ð>     
<11-.>     <31-1>     <51+Q>   4 <71+q>  22 <91-.>     <b1-±>     <d1-Ñ>     <f1+ñ>   1 
<12-.>     <32-2>     <52-R>     <72+r> 105 <92-.>     <b2-²>     <d2-Ò>     <f2-ò>     
<13-.>     <33-3>     <53+S>   4 <73+s> 188 <93-.>     <b3-³>     <d3-Ó>     <f3-ó>     
<14-.>     <34-4>     <54+T>   1 <74+t>  96 <94-.>     <b4-´>     <d4-Ô>     <f4-ô>     
<15-.>     <35-5>     <55+U>   1 <75+u> 108 <95-.>     <b5-µ>     <d5-Õ>     <f5-õ>     
<16-.>     <36-6>     <56+V>   4 <76+v>  37 <96-.>     <b6-¶>     <d6-Ö>     <f6-ö>     
<17-.>     <37-7>     <57-W>     <77-w>     <97-.>     <b7-·>     <d7-×>     <f7-÷>     
<18-.>     <38-8>     <58-X>     <78+x>   5 <98-.>     <b8-¸>     <d8-Ø>     <f8-ø>     
<19-.>     <39-9>     <59-Y>     <79+y>   2 <99-.>     <b9-¹>     <d9-Ù>     <f9+ù>   2 
<1a-.>     <3a+:>   3 <5a-Z>     <7a+z>  12 <9a-.>     <ba-º>     <da-Ú>     <fa-ú>     
<1b-.>     <3b-;>     <5b-[>     <7b-{>     <9b-.>     <bb-»>     <db-Û>     <fb-û>     
<1c-.>     <3c-<>     <5c-\>     <7c-|>     <9c-.>     <bc-¼>     <dc-Ü>     <fc-ü>     
<1d-.>     <3d-=>     <5d-]>     <7d-}>     <9d-.>     <bd+½>  11 <dd-Ý>     <fd-ý>     
<1e-.>     <3e->>     <5e-^>     <7e-~>     <9e-.>     <be-¾>     <de-Þ>     <fe-þ>     
<1f-.>     <3f-?>     <5f-_>     <7f-.>     <9f-.>     <bf-¿>     <df-ß>     <ff-ÿ>     
```

Library
-------
It is also possible to use utrac as a library in your own applications. Let's start with a really simple example:

``` c
  #include <utrac.h>
  #include <stdio.h>
  
  int main (int argc, char** argv) {
     //Initialize utrac (allocates 'ut_session' global variable and loads charsets.dat)
     ut_init();
  
     //Structure 'text' will contain all infos about the text to recognize.
     UtText *text = ut_init_text_heap();
   
     //load file with filename in argv[1] in 'text'.
     ut_load (text, argv[1]);

     //recognize the charset.
     ut_recognize (text);
   
     //'text->charset' is the index of the recognized charset, so print it.
     printf ("Charset is %s\n", ut_session->charset[text->charset].name);
     
     ut_free_text_heap (text);
     
     ut_finish();
  }
```

This example just tries to load the filename provided as argument, recognizes its charset and prints it. It is really basic: if the file does not exists, the example will probably crash, since text->charset will be set to UT_UNSET (-1), and printf will then use an invalid ponter.

The solution is to check the value returned by each call to an utrac function:

``` c
  UtCode rcode = ut_init ();
  if (rcode!=UT_OK) {
     fprintf (stderr, "%s (error %d)\n", ut_error_message(rcode), rcode);
     exit(rcode);
  }
```

It is also possible to apply the recognition on a text in memory rather than in a file. So, rather than calling ut_load(), we can just set text->data to the string to recognize:

``` c
   //replacing line 'ut_load (text, argv[1]);'
	char test[] = "De tout ce qu'à ma peau me fîtes, combien fus-je épaté de fois\n"
	              "Combien à vous qui m'épatates, mon bon petit cœur confus doit\n";
	text->data = test;
```

In this case, the result will depend of the encoding used by your editor. If the text contains some null character, we have to set the size of the text:

``` c
  char test[] = "Oui, mon doux minet, la mini, oui, la mini est la manie\0"
                "Est la manie de Mélanie, Mélanie l'amie d'Amélie...\0"
                "Amélie dont les doux nénés, doux nénés de nounou moulés\0"
                "Dans de molles laines lamées et mêlées de lin milanais...\0";
  text->data = test;
  text->size = sizeof(test) - 1;
```

If we comment the line with the text->size affectation, the charset will be ASCII since the first line has no extended character. With the size set, recognition is done on the whole text, and result will be UTF-8, ISO-8859-1, etc... depending on your editor.

By default, ut_recognize() will only try to find out the charset of the text. To recognize also the type of end of lines, we have to set the flag UT_F_IDENTIFY_EOL before the call to ut_recognize():

``` c
  text->flags |= UT_F_IDENTIFY_EOL;
  ut_recognize (text);   
  printf ("Charset is %s and EOL is %s\n", ut_session->charset[text->charset].name, UT_EOL_NAME[text->eol]);
```

To convert the text, we can use ut_convert() which takes two UtText* as arguments. The first one is the source text, and the second the destination. Input and ouput charsets (or EOL) must be specified in the 'charset' field (or 'eol') of each structures. The second pointer can also be null; the source text will then will be replaced by the converted text, and the output charset (or EOL) will be the one by default (specified in ut_session->charset_default or ut_session->eol_default.

``` c
  UtText * dst_text = ut_init_text_heap();
  dst_text->charset = ut_find_charset("UTF-8");
  dst_text->eol = UT_EOL_CRLF;
  //we can also do 'ut_convert (text, NULL);'
  ut_convert (text, dst_text);
  puts(dst_text->data);
```

Finally, there is also the "progress bar callback" that I would like to explain, but I will write this section later...

Have fun with the utrac library and do not hesitate to mail me about bugs, questions, wishes for the next version, english errors on this page, etc... !
