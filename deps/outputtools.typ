
#let tostring(x) = {
	if (type(x) == content) {
		if (x.has("text")) {
			tostring(x.text)
		} else if (x.has("children")) {
			x.children.map(tostring).join()
		} else if (x.has("body")) {
			tostring(x.body)
		} else {
			" "
		}
	} else {
		str(x)
	}
}
#let output_outline() = context {
	let hs = query(heading)
	let lines = ()
	for h in hs {
		let level = h.level
		let body = h.body
		let n = h.numbering
		let loc = h.location()
		let indent = if level == 1 { "" } else if (level == 2) { "  " }
		let number = if n == none { "" } else {
			numbering(n, ..counter(heading).at(loc))
		}
		let line = (indent, "- ", number, " ", tostring(body), "\n").join()
		lines.push(line)
	}
	let text = lines.join()
	panic(text)
}
#let output_labels() = context {
	let targets = query(selector.or(heading, figure, math.equation))
	let labels = targets.filter(t => t.has("label")).map(t => t.label)
	let content = []
	for l in labels {
		let key = str(l)
		let value = ref(l)
		content += [  #key: #value\ ]
	}
	return content
}