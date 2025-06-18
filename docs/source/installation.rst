Installation
============

Prism is based on version 12.0 of `LÖVE <https://love2d.org>`_ version 12.0, which
is in a stable but pre-release state.

Latest downloads, as of June 2025:

- `Windows <https://github.com/love2d/love/actions/runs/15666539349/artifacts/3331663782>`_
- `Linux AppImage <https://github.com/love2d/love/actions/runs/15666539349/artifacts/3331663775>`_
- `macOS <https://github.com/love2d/love/actions/runs/15666539349/artifacts/3331656441>`_

.. note::

   Prism makes heavy use of Lua type annotations to improve autocomplete and catch typing errors,
   so we recommend installing the `Lua language server <https://luals.github.io/>`_ for your editor.

.. note::

   We've published a VS Code `extension <https://marketplace.visualstudio.com/items?itemName=prismrl.prismrl>`_
   for Prism that includes a few snippets for creating common objects.

Project template
----------------

It is highly recommended to use our project template to kick off games made with prism.
`Click here <https://github.com/new?template_name=prism-template&template_owner=PrismRL>`_ 
to start a new GitHub repository, or use the following command to clone it locally:

.. code:: sh

   git clone --recursive --depth 1 https://github.com/PrismRL/prism-template.git

You can start the game by running ``love .`` in the terminal from the root directory,
or dragging the root folder onto the LÖVE executable.

Upon launching, you should see an ``@`` symbol on the screen. You can
move this character using the following default keys:

* ``WASD`` for movement
* ``QEZC`` for diagonal movement

Without the template
--------------------

Simply clone prism itself into your project:

.. code-block:: sh

   git clone https://github.com/PrismRL/prism.git

Then ``require`` prism:

.. code-block:: lua

   -- prism uses globals, sorry!
   require "path.to.prism"
