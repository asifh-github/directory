## ********************FAILED********************
#### *****timeout 60 ./Arraylist/arraylist.bin --verbose*****
 ``` 

```
#### *****timeout 60 ./word-count/test_strcmp.bin --verbose*****
 ``` 

```
#### *****timeout 60 ./word-count/tokenize.bin ./word-count/txt/input.txt > ./word-count/out/input.txt.tokenize; diff  ./word-count/out/input.txt.tokenize ./word-count/reference/input.txt.tokenize*****
 ```0a1,76
> Lorem
> i
> dolor
> sit
> amet
> consectetur
> adipiscing
> elit
> Sed
> enim
> ligula
> eleifend
> id
> vehicula
> at
> congue
> nec
> est
> Curabitur
> hendrerit
> eros
> eu
> ullamcorper
> maximus
> felis
> ex
> mattis
> nunc
> ut
> tincidunt
> ligula
> orci
> sit
> amet
> nunc
> Integer
> tempor
> dolor
> eget
> diam
> tempus
> posuere
> Vivamus
> fringilla
> tincidunt
> mauris
> a
> pharetra
> Donec
> ante
> justo
> cursus
> semper
> mollis
> at
> semper
> sit
> amet
> ante
> Curabitur
> fringilla
> sapien
> eget
> tristique
> bibendum
> Sed
> metus
> augue
> consectetur
> sit
> amet
> dictum
> quis
> vulputate
> vitae
> ante

```
#### *****timeout 60 ./word-count/dictionary.bin ./word-count/txt/input.txt > ./word-count/out/input.txt.dictionary; diff  ./word-count/out/input.txt.dictionary ./word-count/reference/input.txt.dictionary*****
 ```0a1,57
> 1. Lorem
> 2. i
> 3. dolor
> 4. sit
> 5. amet
> 6. consectetur
> 7. adipiscing
> 8. elit
> 9. Sed
> 10. enim
> 11. ligula
> 12. eleifend
> 13. id
> 14. vehicula
> 15. at
> 16. congue
> 17. nec
> 18. est
> 19. Curabitur
> 20. hendrerit
> 21. eros
> 22. eu
> 23. ullamcorper
> 24. maximus
> 25. felis
> 26. ex
> 27. mattis
> 28. nunc
> 29. ut
> 30. tincidunt
> 31. orci
> 32. Integer
> 33. tempor
> 34. eget
> 35. diam
> 36. tempus
> 37. posuere
> 38. Vivamus
> 39. fringilla
> 40. mauris
> 41. a
> 42. pharetra
> 43. Donec
> 44. ante
> 45. justo
> 46. cursus
> 47. semper
> 48. mollis
> 49. sapien
> 50. tristique
> 51. bibendum
> 52. metus
> 53. augue
> 54. dictum
> 55. quis
> 56. vulputate
> 57. vitae

```
#### *****timeout 60 ./word-count/linecount.bin ./word-count/txt/input.txt > ./word-count/out/input.txt.linecount; diff  ./word-count/out/input.txt.linecount ./word-count/reference/input.txt.linecount*****
 ```0a1,57
> adipiscing: 1 
> felis: 3 
> diam: 4 
> posuere: 5 
> Vivamus: 5 
> Sed: 1 7 
> eleifend: 2 
> est: 2 
> maximus: 3 
> nunc: 3 4 
> semper: 6 6 
> id: 2 
> at: 2 6 
> hendrerit: 2 
> ex: 3 
> orci: 4 
> eget: 4 7 
> justo: 6 
> cursus: 6 
> elit: 1 
> ligula: 2 3 
> nec: 2 
> ullamcorper: 3 
> Integer: 4 
> tempus: 4 
> bibendum: 7 
> metus: 7 
> dictum: 8 
> Lorem: 1 
> amet: 1 4 6 8 
> consectetur: 1 7 
> tempor: 4 
> pharetra: 5 
> augue: 7 
> dolor: 1 4 
> sit: 1 4 6 8 
> fringilla: 5 7 
> ante: 5 6 8 
> mollis: 6 
> sapien: 7 
> i: 1 
> enim: 1 
> vehicula: 2 
> congue: 2 
> Curabitur: 2 6 
> eros: 3 
> ut: 3 
> mauris: 5 
> a: 5 
> Donec: 5 
> vitae: 8 
> eu: 3 
> mattis: 3 
> tincidunt: 3 5 
> tristique: 7 
> quis: 8 
> vulputate: 8 

```

****************************************
## ********************SUCCESS********************