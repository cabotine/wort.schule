// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

import Reveal from "stimulus-reveal-controller"
application.register("reveal", Reveal)

import NestedForm from 'stimulus-rails-nested-form'
application.register('nested-form', NestedForm)

import { Dropdown } from "tailwindcss-stimulus-components"
application.register('dropdown', Dropdown)

import Clipboard from 'stimulus-clipboard'
application.register('clipboard', Clipboard)
