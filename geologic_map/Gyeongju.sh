gmt begin Gyeongju_50K png
        gmt set FORMAT_GEO_MAP D MAP_FRAME_TYPE plain
        gmt plot IE05_Geology_50K_Litho.shp -Jmerc/28c -R128.99/129.25/35.83/36.01 -BWeSn -B0.1 -CGyeongju.cpt -G+z -L -W -aZ=LITHOIDX
        gmt legend Gyeongju_legend -DJRM+w1.5c+o0.2c/0c -F+p0.5p --FONT_ANNOT_PRIMARY=7p
gmt end
