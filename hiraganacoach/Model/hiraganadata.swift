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

let contexts = [
    AssessmentContext(label: "Dojo", hiragana_label: "あ",
                      id: "dojo", assessmentType: "practice",
                      categories: getMasteredCategories()),
    AssessmentContext(label: "Vowels", hiragana_label: "あ",
                      id: "vowels", assessmentType: "practice",
                      categories: [
                        "vowels"
                      ]),
    AssessmentContext(label: "K Consonants", hiragana_label: "か",
                      id: "k_consonants", assessmentType: "practice",
                      categories: [
                        "k_consonants"
                      ]),
    AssessmentContext(label: "S Consonants", hiragana_label: "さ",
                      id: "s_consonants", assessmentType: "practice",
                      categories: [
                        "s_consonants"
                      ]),
    AssessmentContext(label: "T Consonants", hiragana_label: "た",
                      id: "t_consonants", assessmentType: "practice",
                      categories: [
                        "t_consonants"
                      ]),
    AssessmentContext(label: "N Consonants", hiragana_label: "な",
                      id: "n_consonants", assessmentType: "practice",
                      categories: [
                        "n_consonants"
                      ]),
    AssessmentContext(label: "H Consonants", hiragana_label: "は",
                      id: "h_consonants", assessmentType: "practice",
                      categories: [
                        "h_consonants"
                      ]),
    AssessmentContext(label: "M Consonants", hiragana_label: "ま",
                      id: "m_consonants", assessmentType: "practice",
                      categories: [
                        "m_consonants"
                      ]),
    AssessmentContext(label: "Y Consonants", hiragana_label: "や",
                      id: "y_consonants", assessmentType: "practice",
                      categories: [
                        "y_consonants"
                      ]),
    AssessmentContext(label: "R Consonants", hiragana_label: "ら",
                      id: "r_consonants", assessmentType: "practice",
                      categories: [
                        "r_consonants"
                      ]),
    AssessmentContext(label: "W Consonants", hiragana_label: "わ",
                      id: "w_consonants", assessmentType: "practice",
                      categories: [
                        "w_consonants"
                      ]),
    AssessmentContext(label: "Dakuten G", hiragana_label: "が",
                      id: "dakuten_k", assessmentType: "practice",
                      categories: [
                        "dakuten_k"
                      ]),
    AssessmentContext(label: "Dakuten Z", hiragana_label: "ざ",
                      id: "dakuten_s", assessmentType: "practice",
                      categories: [
                        "dakuten_s"
                      ]),
    AssessmentContext(label: "Dakuten D", hiragana_label: "だ",
                      id: "dakuten_t", assessmentType: "practice",
                      categories: [
                        "dakuten_t"
                      ]),
    AssessmentContext(label: "Dakuten B", hiragana_label: "び",
                      id: "dakuten_h_b", assessmentType: "practice",
                      categories: [
                        "dakuten_h_b"
                      ]),
    AssessmentContext(label: "Dakuten P", hiragana_label: "ぴ",
                      id: "dakuten_h_p", assessmentType: "practice",
                      categories: [
                        "dakuten_h_p"
                      ]),
]

let ASSESSMENT = Assessment()
