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
            @path = @path.add(@path_element)
            (expect @path.length()).toEqual(1)

        it "can get the path", ->
            @path = @path.add(@path_element)
            (expect @path.get()).toContain(@path_element)

        it "can handle more than one path", ->
            for i in [1..10]
                @path = @path.add(new PathElement
                            name: "Element #{i}"
                            oid:  i
                        )
            (expect @path.length()).toEqual(10)

        it "can read/write the path to an HTML element", ->
            for i in [1..10]
                @path = @path.add(new PathElement
                            name: "Element #{i}"
                            oid:  i
                        )
            @path.to_element(@el)
            (expect @path.from_element(@el)).toEqual(@path)

        #it "can calculate the nth path element", ->
            #for i in [1..10]
                #@path = @path.add(new PathElement
                            #name: "Element #{i}"
                            #oid:  i
                        #)
            #all = @path.get()
            #pruned = @path.nth(all[5])
            #(expect pruned).toEqual(all[0..5])


    describe "BreadcumbsView", ->
        beforeEach ->
            @path = new Path()
            @view = new BreadcumbsView()
            @el = $("<div>")


# vim: set ft=coffee ts=4 sw=4 expandtab:
