recode_street  <- function(street) {
  street |>
    str_replace_all(regex("[,:\\/]", ignore_case = TRUE), " ") |>
    str_replace_all(regex("[(].+[)]", ignore_case = TRUE), " ") |>
    str_squish() |>  # On fait ca apres avoir efface les ponctuations, au cas il y a des doubles espaces
    str_replace(regex("(^|\\s)(bt(e|[.]|)|bo(i|\u00ee)te|bus)(|\\s)([0-9]+|[a-zA-Z]\\b)", ignore_case = TRUE), " ") |>
    str_replace(regex("\\s(BP|CP)(|\\s)[0-9]+|^(BP|CP)(|\\s)[0-9]+", ignore_case = TRUE), " ") |>
    str_replace(regex("n\u00b0|((^|\\s)(num([.]|)|num(\u00e9|e)ro|n(o|)([.]|)|\\sno)(|\\s)[0-9]+)", ignore_case = TRUE), " ") |>
    str_replace_all(regex("((?<!(\\sd(es|u) )|(Albert( |))|(L(e|\u00e9)opold( |))|(Baudouin( |)))([0-9]++)(?!(( |)e |( |)er |( ||i)(\u00e8|e)me |( |)de |(-|)[a-z]{3,}))([^ ,0-9]+))|(([^ ,0-9]+)(?<!(\\sd(es|u) )|(Albert( |))|(L(e|\u00e9)opold( |))|(Baudouin( |))|([a-z]{3,20}))([0-9]++)(?!(( |)e |( ||i)(\u00e8|e)me |( |)de |( |)er )))|(?<!(\\sd(es|u) )|(Albert( |))|(L(e|\u00e9)opold( |))|(Baudouin( |)))([0-9]++)(?!(( |)e |( ||i)(\u00e8|e)me |( |)de |( |)er ))", ignore_case = TRUE), " ") |>
    str_replace(regex("\\sRez\\s", ignore_case = TRUE), " ") |>
    str_replace(regex("\\sBis\\s", ignore_case = TRUE), " ") |>
    str_replace(regex("\\sRdc\\s", ignore_case = TRUE), " ") |>
    str_replace(regex("(c(m|)dt([.]|)(\\s|))", ignore_case = TRUE), "Commandant ") |>
    str_replace(regex("(^lt[.](\\s|)|^lt\\s)", ignore_case = TRUE), "Luitenant ") |>
    str_replace(regex("((?<!^)\\s+lt[.](\\s|)|(?<!^)\\s+lt\\s)", ignore_case = TRUE), " Lieutenant ") |>
    str_replace(regex("((\\sst[.][-]))|(\\sst(\\s|[-]|[.]))", ignore_case = TRUE), " Saint ") |>
    str_replace(regex("((^st[.][-])|(^st(\\s|[-]|[.])))", ignore_case = TRUE), "Sint ") |>
    str_replace(regex("(\\ss|^s)te(\\s|[-])", ignore_case = TRUE), " Sainte ") |>
    str_trim("left") |> # On fait ca avant les REGEX avec ^ (ci-dessous), au cas ou les etapes precedentes auraient ajoute des blancs au debut des chaines de caracteres (notamment " Saint ", cf. precedent)
    str_replace(regex("(^ch(s|)(\u00e9|e)e\\s|^ch([.]|\\s))", ignore_case = TRUE), "Chaussee ") |>
    str_replace(regex("(^av[.](\\s|)|^av(e|)\\s)", ignore_case = TRUE), "Avenue ") |>
    str_replace(regex("(^kon[.](\\s|)(?=(elisabet|astrid))|^kon\\s)(?=(elisabet|astrid))", ignore_case = TRUE), "Koningin ") |>
    str_replace(regex("(^kon[.](\\s|)(?!(elisabet|astrid))|^kon\\s)(?!(elisabet|astrid))", ignore_case = TRUE), "Koning ") |>
    str_replace(regex("(^prof[.](\\s|)|^prof\\s)", ignore_case = TRUE), "Professor ") |>
    str_replace(regex("(^sq[.](\\s|)|^sq\\s)", ignore_case = TRUE), "Square ") |>
    str_replace(regex("stwg(\\s|[.])", ignore_case = TRUE), "steenweg") |>
    str_replace(regex("(^burg[.](\\s|)|^burg\\s)", ignore_case = TRUE), "Burgemeester ") |>
    str_replace(regex("(^dr[.](\\s|)|^dr\\s)", ignore_case = TRUE), "Dokter ") |>
    str_replace(regex("((?<!^)\\s+dr[.](\\s|)|(?<!^)\\s+dr\\s)", ignore_case = TRUE), " Docteur ") |>
    str_replace(regex("((^b(|l)(|v)d(|[.])\\s)|(^b(|l)(|v)d[.]))", ignore_case = TRUE), "Boulevard ") |>
    str_replace(regex("^Rte\\s", ignore_case = TRUE), "Route ") |>
    str_replace(regex("^pl\\s", ignore_case = TRUE), "Place ") %>%
    ifelse( # Ici on conditionne la correction au fait qu'il n'y ait pas de mots neerlandais, car correction uniquement francophone
      !str_detect(string = ., regex("(laan|straat|plein|dreef|lei)", ignore_case = TRUE)) & str_detect(string = ., regex("(^de\\sla\\s|^du\\s|^des\\s|^d[']|^de\\s|^r\\s|^de\\sl(\\s|)['])", ignore_case = TRUE)),
      str_replace(string = ., regex("^de\\sla\\s", ignore_case = TRUE), "Rue de la ") |>
        str_replace(regex("^du\\s", ignore_case = TRUE), "Rue du ") |>
        str_replace(regex("^des\\s", ignore_case = TRUE), "Rue des ") |>
        str_replace(regex("^d[']", ignore_case = TRUE), "Rue d'") |>
        str_replace(regex("^de\\s", ignore_case = TRUE), "Rue de ") |>
        str_replace(regex("^r\\s", ignore_case = TRUE), "Rue ") |>
        str_replace(regex("^de\\sl(\\s|)[']", ignore_case = TRUE), "Rue de l'"),
      no = .) |>
    str_replace(regex("de\\sl\\s([']|)", ignore_case = TRUE), "de l'") |>
    str_replace(regex("rue\\sd\\s", ignore_case = TRUE), "Rue d'") |>
    str_replace(regex("[']\\s", ignore_case = TRUE), "'") |>
    str_squish() |> # On fait ca avant le regex "(?<=\\s)[A-Za-z]$" (ci-dessous), pour etre sur qu'il fonctionne (car avec un espace derriere la lettre, il n'agit plus)
    str_replace(regex("(?<=\\s)[A-Za-z]$", ignore_case = TRUE), " ") |>
    str_squish() |>  # On fait ca avant le regex "(?<=\\s)[A-Za-z]$" (ci-dessous), pour etre sur qu'il fonctionne (car avec un espace derriere la lettre, il n'agit plus)
    str_replace(regex("(?<=\\s)[A-Za-z]$", ignore_case = TRUE), " ") |>
    str_squish() |>  # On fait ca avant le regex "[-]$" (ci-dessous), pour etre sur qu'il fonctionne (car avec un espace derriere le tiret, il n'agit plus)
    str_replace(regex("([-]$|^[-])", ignore_case = TRUE), " ") |>
    str_squish()
}


utf8ToInt("")
