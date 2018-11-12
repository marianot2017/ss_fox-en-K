
REM Novell
nver         >> &w_cd.RED1.UTI < ent.
nlist * /c   >> &w_cd.RED1.UTI < ent.
map          >> &w_cd.RED1.UTI < ent.
chkvol       >> &w_cd.RED1.UTI < ent.

REM WorkGroup
net use      > &w_cd.RED.UTI

copy &w_cd.RED.UTI+&w_cd.RED1.UTI &w_cd.RED.UTI

del &w_cd.red.uti
del &w_cd.red1.uti
