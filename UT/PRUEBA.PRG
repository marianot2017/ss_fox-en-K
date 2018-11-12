w_sys='sj'
w_cd='h:\sj\'
w_driv='h:'
__curdrv='h:'
w_path='c:\resgua\vianet\'

				set alter to &w_cd.names.
				set alter on
				set conso off
				?'*.mem'
				?'names'
				?w_sys+'\fi\*.*'
				?w_sys+'\fi\00\*.*'
				?w_sys+'\fi\000\*.*'
				?w_sys+'\etc\*.*'
				?w_sys+'\doc\*.*'
				?w_sys+'\form\*.*'
				?w_sys+'\ssf098.*'
				?'foxuser.*'
				?w_sys+'\o_pago\*.*'
				?w_sys+'\listas\*.*'
				?w_sys+'\label\*.*'
				?w_sys+'\impresio\*.*'
				?w_sys+'\*.tmp'
				?w_sys+'\*.err'
				?w_sys+'*.0??'	&& excluyo los posibles resguardos que hubiese dentro del mismo
								&& ya que el arj se mama y los recupera tambien produciendo cagadas
				set conso on
				set alter to
				set alter off

				sele f77
				use

				**no ejecutaba en Windows 2000 porque el limite del parametro es 127 caracteres
				
				w_run='&w_cd.arj x &w_path&w_sys..001 *.* -r -v -jyco -x!&w_cd.names -hf2 -ht&__curdrv.\'
**				w_run='&w_cd.arj x &w_path&w_sys..001 \ -r -v -jyco -x!&w_cd.names -hf2 -ht&__curdrv.\'

**				w_run='arj x &w_driv&w_sys..001 \ -r -v -jyco -x*.mem -x&w_sys.\fi\*.* -x&w_sys.\fi\00\*.* -x&w_sys.\etc\*.* -x&w_sys.\doc\*.* -x&w_sys.\form\*.* -xfoxuser.*'

				wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

				! &w_run
