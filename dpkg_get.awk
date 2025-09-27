BEGIN {
    if (LANG == "") {LANG = lang}
    if (flag ~ /^(-H|-q)?$/) {
        if (flag == "") {flag = "-ihd"}
        else if (flag == "-q") {flag = "-ihdq"}
        else if (flag == "-H") {flag = "-iHd"}
    }
    if (flag == "-Hq" || flag == "-qH") {
        flag = "-iHdq"
    }
    else if ((flag !~ /^-[Hdhiq]+$/ || flag ~ /h/ && flag ~ /H/) && flag != "-s") {
        mode_es = "Modo de uso"
        mode_en = "Usage mode"
        usage = "dpkg-get [-d|-H|-h|-i|-q|-s]"
        if (flag !~ /^-[Hdhiq]+$/) {
            if (lang ~ /^es/) {
                printf "Opción inválida\n%s: %s\n", mode_es, usage
            }
            else {
                printf "Invalid option.\n%s: %s\n", mode_en, usage
            }
            exit 3
        } else {
            if (lang ~ /^es/) {
                print "Error: -h y -H son opciones mutuamente excluyentes. Elija solo una de ellas."
                printf "%s: %s\n", mode_en, usage
            }
            else {
                print "Error: -h and -H cannot be used at the same time. Choose one."
                printf "%s: %s\n", mode_en, usage
            }
            exit  4
        }
    }

    # Estilos
    if (th == "") {th = "\033[1m"}
    if (color_install == "") {color_install = "\033[1;38;5;82m"}
    if (color_hold == "") {color_hold = "\033[1;38;5;27m"}
    if (color_deinstall == "") {color_deinstall = "\033[1;38;5;196m"}
    if (color_total == "") {color_total = "\033[1;38;5;135m"}
    reset = "\033[0m"

    # Encabezado
    if (flag !~ /q/ && flag != "-s") {printf "%s", fprint(th, "STATUS", "", "PACKAGES", reset)}
}
{
    if ($2 == "install" || $2 == "hold") {
        if ($2 == "install") {
            if (flag ~ /i/ && flag !~ /q/) {
                printf "%s", fprint(color_install, $2, reset, $1)
            } else if (flag ~ /i/) {
                printf "%s\n", $1
            }
            inst++
        } else if (flag !~ /H/) {
            if ($2 == "hold")
                if (flag ~ /h|i/ && flag !~ /q/) {
                    holds[++h] = sprintf("%s", fprint(color_hold, $2, reset, $1))
                } else {
                    holds[++h] = sprintf("%s\n", $1)
                }
            }
        t++
    } else if ($2 == "deinstall") {
        if (flag !~ /q/) {
            deinstalls[++d] = sprintf("%s", fprint(color_deinstall, $2, reset, $1))
        } else {
            deinstalls[++d] = sprintf("%s\n", $1)
        }
    }
}
END {
    # Impresión de holds y deinstalls
    if (flag ~ /h|i/) {for (i=1;i<=h;i++) printf holds[i]}
    if (flag ~ /d/ || flag ~ /d/ && flag ~ /i/ && flag ~ /H/) {for (i=1;i<=d;i++) printf deinstalls[i]}

    # Impresión de resúmenes
    if (flag !~ /H/) {
        if (flag !~ /q/ && flag ~ /d/ && flag ~ /i/ || flag == "-s") {
            printf "%stotal:%s %d (%d %sholds%s) %sdeinstalls:%s %d\n", color_total, reset, t, h, color_hold, reset, color_deinstall, reset, d
        } else if (flag == "-h" && flag !~ /q/) {printf "%sholds:%s %d\n", color_hold, reset, h}
        else if (flag ~ /d/ && flag ~ /h/ && flag !~ /q/) {printf "%sholds:%s %d %sdeinstalls:%s %d\n", color_hold, reset, h, color_deinstall, reset, d}
        else if (flag ~ /[hi]+/ && flag !~ /q/) {printf "%stotal:%s %d (%d %sholds%s)\n", color_total, reset, t, h, color_hold, reset}
    } 
    if ((flag == "-d" || flag ~ /d/ && flag ~ /H/) && flag !~ /q/) {printf "%sdeinstalls:%s %d\n", color_deinstall, reset, d}
    else if (flag ~ /i/ && flag ~ /H/ && flag !~ /d|q/) {printf "%sinstalls:%s %d\n", color_install, reset, inst}
    else if (flag ~ /i/ && flag ~ /H/ && flag !~ /q/) {printf "%sinstalls:%s %d %sdeinstalls:%s %d\n", color_install, reset, inst, color_deinstall, reset, d}
}

# Plantilla de Impresión con estilos
function fprint (color, status, reset_status, package, reset_end) {
    if (reset_end == "") {reset_end = ""}
    return sprintf("%s%-10s%s→ %s\n", color, status, reset_status, package, reset_end)
}
