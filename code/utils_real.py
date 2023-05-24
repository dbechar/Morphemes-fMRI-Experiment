import random
import pandas as pd

# depending on condition read in correct file chose. randomly chose
def choose_targets_and_control (condition, language):  
    d_target, d_control = {}, {}
    d_target['condition'], d_control['condition'] = condition, "r"
    
    # GENERATE AFFIXES
    d_target['prefixes'], d_target['root'], d_target['suffixes'] = sample_words(condition, language)
    d_target['word'] = ''.join(d_target['prefixes'] + [d_target['root']] + d_target['suffixes'])
    
    # GENERATE CORRESPONDING MONOMORPHEMES
    d_control['prefixes'], d_control['root'], d_control['suffixes'] = sample_control(language, d_target['word'])
    d_control['word'] = d_control['root']
    
    # ADD TYPE
    d_target['target_type'], d_control['target_type'] = 'target', 'control'
    
    return d_target, d_control


def sample_control(language, target_word):
    r_pool = pd.read_csv (f'../experimental_design/{language}_real/r.csv')
    word = " "
    
    while len(target_word) != len(word[0]): 
        IX = random.choices(range(len(r_pool)), k=1)
        word = r_pool.iloc[IX, r_pool.columns.str.startswith('Root')].values.flatten().tolist()
      
    return [''], str (word[0]), ['']


def sample_words (condition, language):
    affix_pool = pd.read_csv (f'../experimental_design/{language}_real/{condition}.csv')
    n_affixes = len(condition)
    if n_affixes > 1:
        IX = random.choices(range(len(affix_pool)), k=1)
        prefixes = affix_pool.iloc[IX, affix_pool.columns.str.startswith('Prefix')].values.flatten().tolist()
        root = str(affix_pool.iloc[IX, affix_pool.columns.str.startswith('Root')].values.flatten()[0])
        suffixes = affix_pool.iloc[IX, affix_pool.columns.str.startswith('Suffix')].values.flatten().tolist()
        return prefixes, root, suffixes
    else:
        return [''], [''], ['']

def add_errors(d, language):
    prefixes, root, suffixes = d['prefixes'].copy(), d['root'], d['suffixes'].copy()
    if d['condition'].endswith ('long'):    
        condition = d['condition'][:d['condition'].find('_')]
        morphemes_template = list(set(list(condition)))
    else:
        morphemes_template = list(set(list(d['condition']))) # Remove redundancy in control template (e.g., pprs -> prs or rss -> rs)
    
    error_to_which_morpheme = random.choice(morphemes_template)
    
    if error_to_which_morpheme == 'r':
        i_morpheme, target_morpheme = None, d['root']  
    elif error_to_which_morpheme == 'p':
        i_morpheme, target_morpheme = random.choice(list(enumerate(d['prefixes'])))
    elif error_to_which_morpheme == 's':
        i_morpheme, target_morpheme = random.choice(list(enumerate(d['suffixes'])))
        
    i_within_morpheme, target_letter_before_error = random.choice(list(enumerate(list(target_morpheme))))
    
    letter_after_error = substitute_letter(target_letter_before_error, language)
    
   
    d['error_to_which_morpheme'] = error_to_which_morpheme
    d['i_morpheme'] = i_morpheme
    d['i_within_morpheme'] = i_within_morpheme
    d['target_letter_before_error'] = target_letter_before_error
    d['letter_after_error'] = letter_after_error
    
    # BUILD ERROR WORD
    if error_to_which_morpheme == 'r':
        root = list(root)
        root[i_within_morpheme] = letter_after_error
        root = ''.join(root)
    elif error_to_which_morpheme in ['p', 's']:
        morpheme_with_error = list(target_morpheme)
        morpheme_with_error[i_within_morpheme] = letter_after_error
        morpheme_with_error = ''.join(morpheme_with_error)
        if error_to_which_morpheme == 'p':
            prefixes[i_morpheme] = morpheme_with_error
        elif error_to_which_morpheme == 's':
            suffixes[i_morpheme] = morpheme_with_error
    d['error_word'] = ''.join(prefixes + [root] + suffixes)
    
    return d
    

def substitute_letter(letter, language):
    d_letter_groups = {}
    error_letter = ''
    if language == "english":
        for group in ['vowels', 'consonants', 'sonorants']:
            d_letter_groups[group] = {}
        d_letter_groups['vowels']['letters'] = ["a", "e", "i", "o", "u"]
        d_letter_groups['vowels']['weights'] = [8.34, 12.60, 6.71, 7.7, 2.85]
        d_letter_groups['consonants']['letters'] = ["b", "c", "d", "f", "g", "h", "k", "p", "q", "s", "t", "v", "x", "z"]
        d_letter_groups['consonants']['weights'] = [1.54, 2.73, 4.14, 2.03, 1.92, 6.11, 0.87, 4.24,  0.09, 6.11, 9.37, 1.06, 0.20, 0.06]
        d_letter_groups['sonorants']['letters'] = ["j", "l", "m", "n", "r", "w", "y"]
        d_letter_groups['sonorants']['weights'] = [0.23, 2.53, 6.8, 1.66, 5.68, 2.34, 2.04]
    else: 
        for group in ['vowels', 'consonants', 'sonorants']:
            d_letter_groups[group] = {}
        d_letter_groups['vowels']['letters'] = ["a", "â", "à", "e", "ê", "é", "è", "ë", "i", "ï", "î", "o", "ô", "œ", "u", "ü", "û", "ù"]
        d_letter_groups['vowels']['weights'] = [8.13, 0.03, 0.54, 15.10, 0.24, 2.13, 0.35, 0.01, 6.94, 0.01, 0.03, 5.27, 0.07, 0.01, 6.05, 0.02, 0.05, 0.02]
        d_letter_groups['consonants']['letters'] = ["b", "c", "ç", "d", "f", "g", "h", "k", "p", "q", "s", "t", "v", "x", "z"]
        d_letter_groups['consonants']['weights'] = [0.93, 3.15, 0.01, 3.55, 0.96, 0.97, 1.08, 0.16, 3.03, 0.89, 7.91, 7.11, 1.83, 0.42, 0.21]
        d_letter_groups['sonorants']['letters'] = ["j", "l", "m", "n", "r", "w", "y"]
        d_letter_groups['sonorants']['weights'] = [0.71, 5.68, 3.23, 6.24, 6.43, 0.04, 0.19]
        
    for group in d_letter_groups.keys():
        if letter in d_letter_groups[group]['letters']:
            letters, weights = d_letter_groups[group]['letters'], d_letter_groups[group]['weights']
            i_vowel = letters.index(letter)
            del letters[i_vowel], weights[i_vowel]
            error_letter = random.choices(letters, weights)
    
    return error_letter[0]