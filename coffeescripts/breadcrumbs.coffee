# MODELS

class PathElement

    constructor: (options)->
        options ?= {}
        @name = options.name or ""
        @oid  = options.oid or ""

    set_name: (name) ->
        @name = name

    set_oid: (oid) ->
        @oid = oid


class Path

    constructor: (options) ->
        options ?= {}
        @path = options.path or []

    add: (e) ->
        path =  new Path({path: @get()})
        path.path.push(new PathElement(e))
        return path

    length: ->
        @path.length

    get: ->
        _.clone(@path)

    nth: (n) ->
        path = @path[0..n]
        return new Path({path: path})

    to_element: (el) ->
        $(el).data("path", @get())

    from_element: (el) ->
        path = $(el).data("path")
        return new Path({path: path})

    get_path: ->
        path = ""
        for p in @get()
            path += "/#{p.name}"
        return path

# VIEWS

class BreadcumbsView
    constructor: ->
        $(".crumb").live "click", (event) =>
            el = event.target or event.srcElement
            $(@).trigger("clicked", el)

    render: (path, el) ->
        console.debug "BreadcumbsView::render: Render Breadcumbs with Path=", path
        ul = $("<ul id='breadcrumbs'>")

        for seg, i in path.get()
            li = $("<li class='crumb'>")
            this_path = path.nth(i)
            this_path.to_element(li)
            li.text(seg.name)
            ul.append(li)

        $(el).html(ul)
        @


class CellView
    constructor: ->


    render: (path) ->
        li = $("<li class='cell'>")
        path.to_element(li)
        return li


class TableView
    constructor: ->
        $(".cell").live "click", (event) =>
            el = event.target or event.srcElement
            $(@).trigger("clicked", el)

    # get new data (BOM)
    fetch_data: (path, cb) ->
        absolute_path = "#{path.get_path()}/contents.json"
        console.debug "TableView::fetch_data: getJSON for path ", absolute_path
        $.getJSON "#{absolute_path}", (data) =>
            cb(data)

    get_contents: (data) ->
        if data?.contents
            return data.contents
        return []

    render: (data, path, el) =>
        ul = $("<ul id='table'>")

        for item in @get_contents(data)
            view = new CellView()

            this_path = path.add
                          name: item.name
                          id: item.id

            cell = view.render(this_path)
            $(cell).text(item.name)
            ul.append(cell)
        el.html(ul)
        @


jQuery ->

    # Init fake path
    path = new Path()

    # We start at A
    # -----------------------
    path = path.add(
        new PathElement
            name: "A"
            id:    1
    )
    # -----------------------

    bv = new BreadcumbsView()
    tv = new TableView()

    window.render = (path) ->
        console.debug "window.render: path=", path

        window.current_path = path

        # render breadcrumbs
        console.debug "Main::render: Render Breadcrumbs with Path=", path
        el = $("#breadcrumbs-wrapper")
        bv.render(path, el)

        #render table
        console.debug "Main::render: Render Table with Path=", path
        el = $("#table-wrapper")
        tv.fetch_data(path, (data) =>
            tv.render(data, path, el)
        )

    # initial render of fake path
    render(path)


    # Event Handlers for Breadcrumbs
    $(bv).bind("clicked", (event, el) =>
        console.log "Breadcrumb clicked!", el
        handle(el)
    )

    # Event Handlers for Cell
    $(tv).bind("clicked", (event, el) =>
        console.log "Cell clicked!", el
        handle(el)
    )

    handle = (el) ->
        path = new Path()
        p = path.from_element(el)
        render(p)


# ----------------------------------------------------------------------------
# For Jasmine Tests only
window.Path           = Path
window.PathElement    = PathElement
window.BreadcumbsView = BreadcumbsView
window.CellView       = CellView
window.TableView      = TableView
# ----------------------------------------------------------------------------
