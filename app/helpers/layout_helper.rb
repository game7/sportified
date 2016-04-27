# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper

  def title(page_title, opts={})
    content_for(:title) { h(page_title.to_s) }
    content_for(:title_small) { opts[:small] } if opts[:small]
  end

  def page_actions(&block)
    content = capture(&block)
    content_for(:actions) { content }
  end

  def breadcrumbs(crumbs)
    @breadcrumbs = crumbs
  end

  def breadcrumbs?
    @breadcrumbs
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end


end
