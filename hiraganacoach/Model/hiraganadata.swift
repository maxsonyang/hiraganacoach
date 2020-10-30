//
//  hiraganadata.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/21/20.
//

import Foundation

let characterMapping = [
    "a" : "あ",
    "i" : "い",
    "e" : "え",
    "o" : "お",
    "u" : "う",
    "ka" : "か",
    "ki" : "き",
    "ku" : "く",
    "ke" : "け",
    "ko" : "こ",
    "sa" : "さ",
    "shi" : "し",
    "su" : "す",
    "se" : "せ",
    "so" : "そ",
    "ta" : "た",
    "chi" : "ち",
    "tsu" : "つ",
    "te" : "て",
    "to" : "と",
    "na" : "な",
    "ni" : "に",
    "nu" : "ぬ",
    "ne" : "ね",
    "no" : "の",
    "ha" : "は",
    "hi" : "ひ",
    "fu" : "ふ",
    "he" : "へ",
    "ho" : "ほ",
    "ma" : "ま",
    "mi" : "み",
    "mu" : "む",
    "me" : "め",
    "mo" : "も",
    "ya" : "や",
    "yu" : "ゆ",
    "yo" : "よ",
    "ra" : "ら",
    "ri" : "り",
    "ru" : "る",
    "re" : "れ",
    "ro" : "ろ",
    "wa" : "わ",
    "wo" : "を",
    "n" : "ん",
    "ga" : "が",
    "gi" : "ぎ",
    "gu" : "ぐ",
    "ge" : "げ",
    "go" : "ご",
    "za" : "ざ",
    "ji" : "じ",
    "zu" : "ず",
    "ze" : "ぜ",
    "zo" : "ぞ",
    "da" : "だ",
    "dzi" : "ぢ",
    "dzu" : "づ",
    "de" : "で",
    "do" : "ど",
    "ba" : "ば",
    "pa" : "ぱ",
    "bi" : "び",
    "pi" : "ぴ",
    "bu" : "ぶ",
    "pu" : "ぷ",
    "be" : "べ",
    "pe" : "ぺ",
    "bo" : "ぼ",
    "po" : "ぽ",
    "kya" : "きゃ",
    "kyu" : "きゅ",
    "kyo" : "きょ",
    "gya" : "ぎゃ",
    "gyu" : "ぎゅ",
    "gyo" : "ぎょ",
    "sha" : "しゃ",
    "shu" : "しゅ",
    "sho" : "しょ",
    "jya" : "じゃ",
    "jyu" : "じゅ",
    "jyo" : "じょ",
    "cha" : "ちゃ",
    "chu" : "ちゅ",
    "cho" : "ちょ",
    "dya" : "ぢゃ",
    "dyu" : "ぢゅ",
    "dyo" : "ぢょ",
    "nya" : "にゃ",
    "nyu" : "にゅ",
    "nyo" : "にょ",
    "hya" : "ひゃ",
    "hyu" : "ひゅ",
    "hyo" : "ひょ",
    "bya" : "びゃ",
    "byu" : "びゅ",
    "byo" : "びょ",
    "pya" : "ぴゃ",
    "pyo" : "ぴゅ",
    "pyu" : "ぴょ",
    "mya" : "みゃ",
    "myu" : "みゅ",
    "myo" : "みょ",
    "rya" : "りゃ",
    "ryu" : "りゅ",
    "ryo" : "りょ"
]
let hiragana_categories = [
    // Base Hiragana Vowels and Consonants
    "vowels" : ["a", "e", "i", "u", "o"],
    "k_consonants" : ["ka", "ki", "ku", "ke", "ko"],
    "s_consonants" : ["sa", "shi", "su", "se", "so"],
    "t_consonants" : ["ta", "chi", "tsu", "te", "to"],
    "n_consonants" : ["na", "ni", "nu", "ne", "no"],
    "h_consonants" : ["ha", "hi", "fu", "he", "ho"],
    "m_consonants" : ["ma", "mi", "mu", "me", "mo"],
    "y_consonants" : ["ya", "yu", "yo"],
    "r_consonants" : ["ra", "ri", "ru", "re", "ro"],
    "w_consonants" : ["wa", "wo", "n"],
    
    // Dakuten
    "dakuten_k" : ["ga", "gi", "gu", "ge", "go"],
    "dakuten_s" : ["za", "ji", "zu", "ze", "zo"],
    "dakuten_t" : ["da", "dzi", "dzu", "de", "do"],
    "dakuten_h_b" : ["ba", "bi", "bu", "be", "bo"],
    "dakuten_h_p" : ["pa", "pi", "pu", "pe", "po"],
    
    // Combination Hiragana
    "k_combination" : ["kya", "kyu", "kyo"],
    "g_combination" : ["gya", "gyu", "gyo"],
    "s_combination" : ["sha", "shu", "sho"],
    "j_combination" : ["jya", "jyu", "jyo"],
    "c_combination" : ["cha", "chu", "cho"],
    "d_combination" : ["dya", "dyu", "dyo"],
    "n_combination" : ["nya", "nyu", "nyo"],
    "h_combination" : ["hya", "hyu", "hyo"],
    "b_combination" : ["bya", "byu", "byo"],
    "p_combination" : ["pya", "pyu", "pyo"],
    "m_combination" : ["mya", "myu", "myo"],
    "r_combination" : ["rya", "ryu", "ryo"]
]

// Category Labels

var ACCURACY_TABLE = AccuracyTable()

let categories = [
    Category(label: "Dojo", hiragana_label: "あ", id: "dojo", accuracyTable: ACCURACY_TABLE,
             categories: [
                "vowels",
                "k_consonants",
                "s_consonants",
                "t_consonants",
                "n_consonants",
                "h_consonants"
             ]),
    Category(label: "Vowels", hiragana_label: "あ", id: "vowels", accuracyTable: ACCURACY_TABLE,
             categories: [
                "vowels"
             ]),
    Category(label: "K Consonants", hiragana_label: "か", id: "k_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "k_consonants"
             ]),
    Category(label: "S Consonants", hiragana_label: "さ", id: "s_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "s_consonants"
             ]),
    Category(label: "T Consonants", hiragana_label: "た", id: "t_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "t_consonants"
             ]),
    Category(label: "N Consonants", hiragana_label: "な", id: "n_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "n_consonants"
             ]),
    Category(label: "H Consonants", hiragana_label: "は", id: "h_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "h_consonants"
             ]),
    Category(label: "M Consonants", hiragana_label: "ま", id: "m_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "m_consonants"
             ]),
    Category(label: "Y Consonants", hiragana_label: "や", id: "y_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "y_consonants"
             ]),
    Category(label: "R Consonants", hiragana_label: "ら", id: "r_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "r_consonants"
             ]),
    Category(label: "W Consonants", hiragana_label: "わ", id: "w_consonants", accuracyTable: ACCURACY_TABLE,
             categories: [
                "w_consonants"
             ]),
    Category(label: "G Dakuten", hiragana_label: "ら", id: "dakuten_k", accuracyTable: ACCURACY_TABLE,
             categories: [
                "r_consonants"
             ]),
    Category(label: "Z Dakuten", hiragana_label: "ら", id: "dakuten_s", accuracyTable: ACCURACY_TABLE,
             categories: [
                "dakuten_s"
             ]),
    Category(label: "D Dakuten", hiragana_label: "ら", id: "dakuten_t", accuracyTable: ACCURACY_TABLE,
             categories: [
                "dakuten_t"
             ]),
    Category(label: "B Dakuten", hiragana_label: "ら", id: "dakuten_h_b", accuracyTable: ACCURACY_TABLE,
             categories: [
                "dakuten_h_b"
             ]),
    Category(label: "P Dakuten", hiragana_label: "ら", id: "dakuten_h_p", accuracyTable: ACCURACY_TABLE,
             categories: [
                "dakuten_h_p"
             ]),
]
