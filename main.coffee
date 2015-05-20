_ = window.global = {}

_.MAX = 10
_.MIN = 4

_.HEADER_SIZE = 120
_.BUTTON_SIZE = 30
_.LABEL_SIZE = 40
_.BUTTON_MARGIN = 10

_.TOP = _.HEADER_SIZE + _.BUTTON_SIZE + _.BUTTON_MARGIN

_.COL = 4
_.ROW = 4

# =====================================================================================

c = (dat)-> console.log dat

caltivate = (num) ->
	num = if num >= _.MAX then _.MAX else num 
	num = if num <= _.MIN then _.MIN else num 
	num

do getWindowSize = ()->  
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]
  _.WIDTH = w.innerWidth || e.clientWidth || g.clientWidth
  _.HEIGHT = w.innerHeight|| e.clientHeight|| g.clientHeight

updateUI = ()->

	_.SQUARE_SIZE = _.WIDTH/(2*_.COL)
	_.CHESS_WIDTH = _.SQUARE_SIZE * _.COL
	_.CHESS_HEIGHT = _.SQUARE_SIZE * _.ROW

	$("#ChessTable").css 
		width: "#{_.CHESS_WIDTH}px"
		height: "#{_.CHESS_HEIGHT}px"
		top: "#{_.TOP}px"
		left: "#{_.WIDTH/4}px"

	$("#ColDecrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/4}px"} 
	$("#ColIncrease").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH*3/4 - _.BUTTON_SIZE}px"}
	$("#ColNumber").css {top: "#{_.HEADER_SIZE}px", left: "#{_.WIDTH/2 - _.LABEL_SIZE/2}px"}
	$("#RowDecrease").css {top: "#{_.TOP}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowIncrease").css {top: "#{_.TOP + _.CHESS_HEIGHT - _.BUTTON_SIZE}px", left: "#{_.WIDTH/4 - _.BUTTON_SIZE - _.BUTTON_MARGIN}px"}
	$("#RowNumber").css {top: "#{_.TOP + _.CHESS_HEIGHT/2 - _.LABEL_SIZE/2}px", left: "#{_.WIDTH/4 - _.LABEL_SIZE}px"}

	_.SVG.attr("width", _.CHESS_WIDTH).attr("height", _.CHESS_HEIGHT)
	
	_.RECT = _.RECT.data(_.TABLE)      
	_.RECT.enter().append("rect")
				.on("dblclick", (d,i)->
					c "clidked"
					_.START = i
					updateUI()
				).on("click",(d,i)-> 
					_.TABLE[i] = !_.TABLE[i]
					updateUI()
				)
				
	_.RECT.attr("width", (d)-> _.SQUARE_SIZE)
			.attr("height", (d)-> _.SQUARE_SIZE)
			.attr("x", (d,i)-> (i % _.COL) * _.SQUARE_SIZE )
			.attr("y", (d,i)-> parseInt(i / _.COL) * _.SQUARE_SIZE )
			.attr("fill", (d)-> if d then "#C00" else "#EEE")
			.attr("stroke", (d)-> if d then "#FFF" else "#FFF")
			.attr("stroke-width", "2px")

	_.RECT.exit().remove()

	_.START_MARKER = _.START_MARKER.data([_.START])
	_.START_MARKER.enter().append("rect")

	_.START_MARKER.attr("width", (d)-> _.SQUARE_SIZE-10)
			.attr("height", (d)-> _.SQUARE_SIZE-10)
			.attr("x", (d)-> ((d % _.COL) * _.SQUARE_SIZE)+5 )
			.attr("y", (d)-> (parseInt(d / _.COL) * _.SQUARE_SIZE)+5 )
			.attr("fill", "none")
			.attr("stroke", "#FF0")
			.attr("stroke-width", "10px")
	_.START_MARKER.exit().remove()

	_.ANSWER_LINE = _.ANSWER_LINE.data(_.ANSWER)

	_.ANSWER_CIRCLE = _.ANSWER_CIRCLE.data(_.ANSWER)

	_.ANSWER_TEXT = _.ANSWER_TEXT.data(_.ANSWER)
	_.ANSWER_TEXT.enter().append("text")
	_.ANSWER_TEXT.attr("width", (d)-> _.SQUARE_SIZE-10)
			.attr("height", (d)-> _.SQUARE_SIZE-10)
			.attr("x", (d,i)-> ((i % _.COL) * _.SQUARE_SIZE) + (_.SQUARE_SIZE/2) )
			.attr("y", (d,i)-> (parseInt(i / _.COL) * _.SQUARE_SIZE) + (_.SQUARE_SIZE/2) )
			.text((d,i) -> i)
	_.ANSWER_TEXT.exit().remove()

	return
	
do updateColumn = ()->

	$("#ColNumber").text _.COL

	if _.COL == _.MIN 
		$("#ColDecrease").addClass("disabled")
	else if _.COL == _.MAX 
		$("#ColIncrease").addClass("disabled")
	else
		$("#ColIncrease").removeClass()
		$("#ColDecrease").removeClass()

do updateRow = ()->

	$("#RowNumber").text _.ROW
	
	if _.ROW == _.MIN 
		$("#RowDecrease").addClass("disabled")
	else if _.ROW == _.MAX 
		$("#RowIncrease").addClass("disabled")
	else
		$("#RowIncrease").removeClass()
		$("#RowDecrease").removeClass()

updateTableByIncreaceCol = ()->

	TEMP = []
	length = (_.COL * _.ROW)-1
	c length

	for i in [0..length]
		TEMP[i] = true
	PCOL = _.COL-1
	for t,i in _.TABLE
		row = parseInt(i/PCOL)
		TEMP[i + row] = _.TABLE[i]

	_.TABLE = TEMP

updateTableByDecreaceCol = ()->

	TEMP = []
	length = (_.COL * _.ROW)-1
	c length

	for i in [0..length]
		TEMP[i] = true

	PCOL = _.COL + 1
	for i in [0..length]
		row = parseInt(i/PCOL)
		TEMP[i - row] = _.TABLE[i]

	_.TABLE = TEMP

updateTableByIncreaceRow = ()->
	TEMP = []
	length = (_.COL * _.ROW)-1
	c length
	for i in [0..length]
		TEMP[i] = true
	for t,i in _.TABLE
		TEMP[i] = t
	_.TABLE = TEMP

updateTableByDecreaceRow = ()->
	TEMP = []
	length = (_.COL * _.ROW)-1
	c length
	for i in [0..length]
		TEMP[i] = _.TABLE[i]
	_.TABLE = TEMP

do initializeUI = ()->

	# InitializeTable
	_.TABLE = []
	_.ANSWER = [1,2,3,4,5,6,7,8]
	_.START = 0

	for i in [1.._.COL]
		for j in [1.._.ROW]
			_.TABLE.push true

	_.SVG = d3.select("#ChessTable").append("svg")

	_.RECT_GROUP = _.SVG.append("g").attr("id", "Rects")
	_.START_GROUP = _.SVG.append("g").attr("id", "StartGroup")
	_.ANSWER_GROUP = _.SVG.append("g").attr("id", "AnswerGroup")
	
	_.RECT = _.RECT_GROUP.selectAll("rect")
	_.START_MARKER = _.START_GROUP.selectAll("rect")

	_.ANSWER_LINE = _.ANSWER_GROUP.selectAll("path")
	_.ANSWER_CIRCLE = _.ANSWER_GROUP.selectAll("circle")
	_.ANSWER_TEXT = _.ANSWER_GROUP.selectAll("text")


	do updateUI

	$("#ColIncrease").click ()-> 

		needsUpdateCol = _.COL != _.MAX
		needsUpdateRow = _.ROW != _.MAX

		_.COL = caltivate(_.COL + 1) 
		_.ROW = caltivate(_.ROW + 1) 
	
		if needsUpdateCol
			do updateTableByIncreaceCol 
		else if needsUpdateRow
			do updateTableByIncreaceRow 

		do updateColumn
		do updateRow
		do updateUI

	$("#ColDecrease").click ()-> 
		
		needsUpdateCol = _.COL != _.MIN
		needsUpdateRow = _.ROW != _.MAX

		_.COL = caltivate(_.COL - 1) 
		_.ROW = caltivate(_.ROW - 1) 

		if needsUpdateCol
			do updateTableByDecreaceCol 
		else if needsUpdateRow
			do updateTableByDecreaceRow

		do updateColumn
		do updateRow
		do updateUI

	$("#RowIncrease").click ()-> 

		_.ROW = caltivate(_.ROW + 1) 

		do updateTableByIncreaceRow 
		do updateRow
		do updateUI

	$("#RowDecrease").click ()-> 

		_.ROW = caltivate(_.ROW - 1) 

		do updateTableByDecreaceRow
		do updateRow
		do updateUI

	$("#Execution").click ()->
		$button = $(@)
		if $button.hasClass("calucurated")
			$button.text("CALC")
			$button.removeClass("calucurated")
		else
			$button.text("CLEAR")
			$button.addClass("calucurated")



window.onresize = ()->
	do getWindowSize
	do updateUI