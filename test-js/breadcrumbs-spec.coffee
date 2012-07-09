describe "Breadcrumbs", ->

    describe "PathElement", ->
        beforeEach ->
            @path_element = new PathElement()

         it "contains an name attribute", ->
             (expect @path_element.name).toBeDefined()

         it "contains an oid attribute", ->
             (expect @path_element.oid).toBeDefined()


    describe "Path", ->
        beforeEach ->
            @path = new Path()
            @path_element = new PathElement
                 name: "A"
                 oid:  "1"

            @el = $("<div>")

        it "contains a path attribute", ->
            (expect @path.path).toBeDefined()

        it "can add a path element", ->
            @path.add(@path_element)
            (expect @path.length()).toEqual(1)

        it "can get the path", ->
            @path.add(@path_element)
            (expect @path.get()).toContain(@path_element)

        it "can handle more than one path", ->
            for i in [1..10]
                @path.add(new PathElement
                    name: "Element #{i}"
                    id:    i
                )
            (expect @path.length()).toEqual(10)

        it "can read/write the path to an HTML element", ->
            for i in [1..10]
                @path.add(new PathElement
                    name: "Element #{i}"
                    id:    i
                )
            @path.to_element(@el)
            (expect @path.from_element(@el)).toEqual(@path.get())


        it "can calculate the nth path element", ->
            for i in [1..10]
                @path.add(new PathElement
                    name: "Element #{i}"
                    id:    i
                )
            all = @path.get()
            pruned = @path.nth(all[5])
            (expect pruned).toEqual(all[0..5])
            console.debug all
            console.debug pruned


    describe "BreadcumbsView", ->
        beforeEach ->
            @path = new Path()
            @view = new BreadcumbsView()
            @el = $("<div>")

        it "handles a click ", ->
            for i in [1..10]
                @path.add(new PathElement
                    name: "Element #{i}"
                    id:    i
                )
            @path.to_element(@el)
            console.debug "BreadcumbsView: path=", @path
            @view.clicked(@el)

# vim: set ft=coffee ts=4 sw=4 expandtab:
