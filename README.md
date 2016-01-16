# wikibeef
Finds the beef between two wikipedia articles

# Usage

```
ruby chef.rb --from <WIKIPEDIA PAGE> --to <WIKIPEDIA PAGE> --max-patties <MAX DEPTH> --min-burgers <MINIMUM HITS> --max-sous-chefs <NUM THREADS>
```

# Future Work
I want to find a way to exclude 'external links' and 'see also' links via the mediawiki API
Gonna improve the memory usage as well

# Example

Find the minimum number of pages from 'Chef' to 'Knife', using 4 threads
```
ruby chef.rb --from 'Chef' --to 'Knife' --max-sous-chefs 4
```

Output:
```
  .--,--.
  '.  ,.'  _
   |___|  | |
   :o o:  |_|
  _:~^~:_  |
 |       | |
It's 2016-01-16 11:37:56 -0500! Let's get cooking!!!
I will attempt to make 1 burger from Chef to Knife, with as many as 7 patties~!
I may hire up to 4 Sous Chefs!
Making patty number 1!
There are 1 meats in this patty.
Making patty number 2!
There are 378 meats in this patty.
ORDER UP!!!
Chef -> Ancient Roman cuisine -> Knife
Dinner is served! It took 1.8 seconds! Sorry for the wait.
```

Find the minimum number of pages from 'Barack Obama' to 'Donald Trump', minimum of three burgers
```
ruby chef.rb --from 'Barack Obama' --to 'Donald Trump' --min-burgers 3
```

Output:
```
  .--,--.
  '.  ,.'  _
   |___|  | |
   :o o:  |_|
  _:~^~:_  |
 |       | |
It's 2016-01-16 11:38:36 -0500! Let's get cooking!!!
I will attempt to make 3 burgers from Barack Obama to Donald Trump, with as many as 7 patties~!
I may hire up to 8 Sous Chefs! Qu'est-ce une grande cuisine!
Making patty number 1!
There are 1 meats in this patty.
Making patty number 2!
There are 1594 meats in this patty.
ORDER UP!!!
Barack Obama -> University of Pennsylvania -> Donald Trump
ORDER UP!!!
Barack Obama -> Alan Keyes -> Donald Trump
ORDER UP!!!
Barack Obama -> Barack Obama citizenship conspiracy theories -> Donald Trump
Dinner is served! It took 4.0 seconds! Sorry for the wait.
```

Find the minimum pages between 'Vegan' to 'Doctor Doom', using 12 sous chefs
```
ruby chef.rb --from 'Vegan' --to 'Doctor Doom' --max-sous-chefs 12
```

Output
```
  .--,--.
  '.  ,.'  _
   |___|  | |
   :o o:  |_|
  _:~^~:_  |
 |       | |
It's 2016-01-16 12:26:29 -0500! Let's get cooking!!!
I will attempt to make 1 burger from Vegan to Doctor Doom, with at least 1 patties and as many as 7 patties~!
I may hire up to 12 Sous Chefs! Qu'est-ce une grande cuisine!
Making patty number 1!
There are 1 meats in this patty.
Making patty number 2!
There are 902 meats in this patty.
Making patty number 3!
There are 77387 meats in this patty.
ORDER UP!!!
Vegan -> Genetically modified food controversies -> Powered exoskeleton -> Doctor Doom
Dinner is served! It took 174.9 seconds! Sorry for the wait.
```