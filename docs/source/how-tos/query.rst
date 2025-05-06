Queries
=======

Most roguelikes involve systems where you need to efficiently find actors or entities
with certain components—such as all enemies, or everyone at a specific location. Prism
provides a built-in query system to make this easy and efficient.

Basic Usage
-----------

To start a query, call :lua:func:`IQueryable.query` with the component types you want to require. This
interface is implemented by :lua:class:`Level`, :lua:class:`MapBuilder`, and :lua:class:`ActorStorage`.

.. code:: lua

    local query = level:query(prism.components.Controller, prism.components.Collider)

This creates a :lua:class:`Query` object. You can add more required components later with
:lua:func:`Query.with`.

.. code:: lua

    query:with(prism.components.Senses)

You can also restrict the query to a single tile with :lua:func:`Query.at`.

.. code:: lua

    query:at(10, 5)

Iterating Over Results
----------------------

Use :lua:func:`Query.iter` to get an iterator over matching actors and their components:

.. code:: lua

    for actor, controller, collider, senses in query:iter() do
        -- do stuff
    end

Alternatively, use :lua:func:`Query.each` to apply a function to each match:

.. code:: lua

    query:each(function(actor, controller, collider, senses)
        -- do stuff
    end)

Gathering Results
-----------------

To gather results into a list, use :lua:func:`Query.gather`:

.. code:: lua

    local results = query:gather()

    for _, actor in ipairs(results) do
        -- Do something with them
    end


Putting It Together
-----------------

Here's an example of it all put together:

.. code:: lua

    local query = level:query(prism.components.Controller, prism.components.Senses)
        :with(prism.components.Senses)
        :at(x, y)

    for actor, controller, collider, senses in query:iter() do
        -- do stuff
    end

.. note::

   Query performance is optimized internally based on your filters.
   Position-based queries and single-component queries are particularly fast.