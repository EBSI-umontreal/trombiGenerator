(:
Sources :
https://stackoverflow.com/questions/28724061/generating-a-document-with-list-of-files-in-a-directory-using-xslt-2-0
https://saxonica.plan.io/issues/3809
https://stackoverflow.com/questions/25679232/required-item-type-of-first-operand-of-is-node-supplied-value-has-item-ty
https://stackoverflow.com/questions/33663054/xquery-get-distinct-values-after-tokenize
:)
declare option saxon:output "indent=yes";

<album>
{
	let $string := iri-to-uri('./album/?select=*.(jpg|png);recurse=yes')
	let $input := uri-collection($string)
	
	let $folders-all := for $i in $input
						return tokenize($i, '/')[position() = (last()-1)]
	
	let $folders-unique := distinct-values($folders-all)
	
	for $x in $folders-unique
	return <folder name="{$x}">{
		for $i in $input
			return 
				if ($x=tokenize($i, '/')[position() = (last()-1)])
				then (
					<file>{substring-after($i,concat($x,'/'))}</file>
				)
				else ()
	}
	</folder>
}
</album>
