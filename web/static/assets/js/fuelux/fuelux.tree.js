/*
 * Fuel UX Tree https://github.com/ExactTarget/fuelux Copyright (c) 2014 ExactTarget Licensed under the BSD New license.
 */

// -- BEGIN UMD WRAPPER PREFACE --
// For more information on UMD visit:
// https://github.com/umdjs/umd/blob/master/jqueryPlugin.js
(function(factory) {
	if (typeof define === 'function' && define.amd) {
		// if AMD loader is available, register as an anonymous module.
		define([ 'jquery' ], factory);
	} else {
		// OR use browser globals if AMD is not present
		factory(jQuery);
	}
}(function($) {
	// -- END UMD WRAPPER PREFACE --

	// -- BEGIN MODULE CODE HERE --

	var old = $.fn.tree;

	// TREE CONSTRUCTOR AND PROTOTYPE

	var Tree = function(element, options) {
		this.$element = $(element);
		this.options = $.extend({}, $.fn.tree.defaults, options);

		this.$element.on('click.fu.tree', '.tree-item', $.proxy(function(ev) {
			this.selectItem(ev.currentTarget);
		}, this));
		// this.$element.on('click.fu.tree', '.tree-branch-name', $.proxy( function(ev) { this.openFolder(ev.currentTarget); }, this));
		this.$element.on('click.fu.tree', '.tree-branch-header', $.proxy(function(ev) {
			this.openFolder(ev.currentTarget);
		}, this));
		// ACE

		// ACE
		/**
		 * if( this.options.folderSelect ){ this.$element.off('click.fu.tree', '.tree-branch-header'); this.$element.on('click.fu.tree', '.icon-caret', $.proxy( function(ev) {
		 * this.openFolder($(ev.currentTarget).parent()); }, this)); this.$element.on('click.fu.tree', '.tree-branch-header', $.proxy( function(ev) { this.selectFolder($(ev.currentTarget)); }, this)); }
		 */

		this.render();
	};

	Tree.prototype = {
		constructor : Tree,

		destroy : function() {
			// any external bindings [none]
			// empty elements to return to original markup
			this.$element.find("li:not([data-template])").remove();

			this.$element.remove();
			// returns string of markup
			return this.$element[0].outerHTML;
		},

		render : function() {
			this.populate(this.$element);
		},

		populate : function($el) {
			var self = this;
			var $parent = ($el.hasClass('tree')) ? $el : $el.parent();
			var loader = $parent.find('.tree-loader:eq(0)');
			var treeData = $parent.data();

			loader.removeClass('hide');
			this.options.dataSource(treeData ? treeData : {}, function(items) {
				loader.addClass('hide');

				$.each(items.data, function(index, value) {
					var $entity;

					if (value.type === 'folder') {
						$entity = self.$element.find('[data-template=treebranch]:eq(0)').clone().removeClass('hide').removeAttr('data-template');
						$entity.data(value);
						$entity.find('.tree-branch-name > .tree-label').html(value.text || value.name);

						// ACE
						var header = $entity.find('.tree-branch-header');

						if ('icon-class' in value)
							header.find('i').addClass(value['icon-class']);

						if ('additionalParameters' in value && 'item-selected' in value.additionalParameters && value.additionalParameters['item-selected'] == true) {
							setTimeout(function() {
								header.trigger('click')
							}, 0);
						}

					} else if (value.type === 'item') {
						$entity = self.$element.find('[data-template=treeitem]:eq(0)').clone().removeClass('hide').removeAttr('data-template');
						$entity.find('.tree-item-name > .tree-label').html(value.text || value.name);
						$entity.data(value);

						// ACE
						if ('additionalParameters' in value && 'item-selected' in value.additionalParameters && value.additionalParameters['item-selected'] == true) {
							$entity.addClass('tree-selected');
							$entity.find('i').removeClass(self.options['unselected-icon']).addClass(self.options['selected-icon']);
							// $entity.closest('.tree-folder-content').show();
						}
					}

					// Decorate $entity with data or other attributes making the
					// element easily accessable with libraries like jQuery.
					//
					// Values are contained within the object returned
					// for folders and items as attr:
					//
					// {
					// name: "An Item",
					// type: 'item',
					// attr = {
					// 'classes': 'required-item red-text',
					// 'data-parent': parentId,
					// 'guid': guid,
					// 'id': guid
					// }
					// };
					//
					// the "name" attribute is also supported but is deprecated for "text"

					// add attributes to tree-branch or tree-item
					var attr = value['attr'] || value.dataAttributes || [];
					$.each(attr, function(key, value) {
						switch (key) {
							case 'cssClass':
							case 'class':
							case 'className':
								$entity.addClass(value);
								break;

							// allow custom icons
							case 'data-icon':
								$entity.find('.icon-item').removeClass().addClass('icon-item ' + value);
								$entity.attr(key, value);
								break;

							// ARIA support
							case 'id':
								$entity.attr(key, value);
								$entity.attr('aria-labelledby', value + '-label');
								$entity.find('.tree-branch-name > .tree-label').attr('id', value + '-label');
								break;

							// id, style, data-*
							default:
								$entity.attr(key, value);
								break;
						}
					});

					// add child nodes
					if ($el.hasClass('tree-branch-header')) {
						$parent.find('.tree-branch-children:eq(0)').append($entity);
					} else {
						$el.append($entity);
					}
				});

				// return newly populated folder
				self.$element.trigger('loaded.fu.tree', $parent);
			});
		},

		selectItem : function(el) {
			if (this.options['selectable'] == false)
				return;// ACE

			var $el = $(el);
			var selData = $el.data();
			var $all = this.$element.find('.tree-selected');
			var data = [];
			var $icon = $el.find('.icon-item');

			if (this.options.multiSelect) {
				$.each($all, function(index, value) {
					var $val = $(value);
					if ($val[0] !== $el[0]) {
						data.push($(value).data());
					}
				});
			} else if ($all[0] !== $el[0]) {
				//
				$all.removeClass('tree-selected').find('i').removeClass(this.options['selected-icon']).addClass(this.options['unselected-icon']);// ACE
				data.push(selData);
			}

			var eventType = 'selected';
			if ($el.hasClass('tree-selected')) {
				eventType = 'deselected';
				$el.removeClass('tree-selected');
				if ($icon.hasClass(this.options['selected-icon']) || $icon.hasClass(this.options['unselected-icon'])) {
					$icon.removeClass(this.options['selected-icon']).addClass(this.options['unselected-icon']);// ACE
				}
			} else {
				$el.addClass('tree-selected');
				// add tree dot back in
				if ($icon.hasClass(this.options['selected-icon']) || $icon.hasClass(this.options['unselected-icon'])) {
					$icon.removeClass(this.options['unselected-icon']).addClass(this.options['selected-icon']);// ACE
				}
				if (this.options.multiSelect) {
					data.push(selData);
				}
			}

			this.$element.trigger(eventType + '.fu.tree', {
				target : selData,
				selected : data
			});

			// Return new list of selected items, the item
			// clicked, and the type of event:
			$el.trigger('updated.fu.tree', {
				selected : data,
				item : $el,
				eventType : eventType
			});
		},

		openFolder : function(el) {
			var $el = $(el); // tree-branch-name
			var $branch;
			var $treeFolderContent;
			var $treeFolderContentFirstChild;

			// if item select only
			// ACE
			/**
			 * if (!this.options.folderSelect) { $el = $(el).parent(); // tree-branch, if tree-branch-name clicked }
			 */

			$branch = $el.closest('.tree-branch'); // tree branch
			$treeFolderContent = $branch.find('.tree-branch-children');
			$treeFolderContentFirstChild = $treeFolderContent.eq(0);

			// manipulate branch/folder
			var eventType, classToTarget, classToAdd;
			if ($el.find('.' + $.trim(this.options['close-icon'].replace(/(\s+)/g, '.'))).length) {// ACE
				eventType = 'opened';
				classToTarget = this.options['close-icon'];// ACE
				classToAdd = this.options['open-icon'];// ACE

				$branch.addClass('tree-open');
				$branch.attr('aria-expanded', 'true');

				$treeFolderContentFirstChild.removeClass('hide');
				if (!$treeFolderContent.children().length) {
					this.populate($treeFolderContent);
				}

			} else if ($el.find('.' + $.trim(this.options['open-icon'].replace(/(\s+)/g, '.')))) {
				eventType = 'closed';
				classToTarget = this.options['open-icon'];// ACE
				classToAdd = this.options['close-icon'];// ACE

				$branch.removeClass('tree-open');
				$branch.attr('aria-expanded', 'false');
				$treeFolderContentFirstChild.addClass('hide');

				// remove if no cache
				if (!this.options.cacheItems) {
					$treeFolderContentFirstChild.empty();
				}

			}

			$branch.find('> .tree-branch-header .icon-folder').eq(0)
			// .removeClass(this.options['close-icon'] + ' ' + this.options['open-icon'])
			.removeClass(classToTarget)// ACE
			.addClass(classToAdd);

			this.$element.trigger(eventType + '.fu.tree', $branch.data());
		},

		selectFolder : function(clickedElement) {
			var $clickedElement = $(clickedElement);
			var $clickedBranch = $clickedElement.closest('.tree-branch');
			var $selectedBranch = this.$element.find('.tree-branch.tree-selected');
			var clickedData = $clickedBranch.data();
			var selectedData = [];
			var eventType = 'selected';

			// select clicked item
			if ($clickedBranch.hasClass('tree-selected')) {
				eventType = 'deselected';
				$clickedBranch.removeClass('tree-selected');
			} else {
				$clickedBranch.addClass('tree-selected');
			}

			if (this.options.multiSelect) {

				// get currently selected
				$selectedBranch = this.$element.find('.tree-branch.tree-selected');

				$.each($selectedBranch, function(index, value) {
					var $value = $(value);
					if ($value[0] !== $clickedElement[0]) {
						selectedData.push($(value).data());
					}
				});

			} else if ($selectedBranch[0] !== $clickedElement[0]) {
				$selectedBranch.removeClass('tree-selected');

				selectedData.push(clickedData);
			}

			this.$element.trigger(eventType + '.fu.tree', {
				target : clickedData,
				selected : selectedData
			});

			// Return new list of selected items, the item
			// clicked, and the type of event:
			$clickedElement.trigger('updated.fu.tree', {
				selected : selectedData,
				item : $clickedElement,
				eventType : eventType
			});
		},

		selectedItems : function() {
			// var $sel = this.$element.find('.tree-selected');
			var $sel = this.$element.find('.tree-branch.tree-open');
			var data = [];

			$.each($sel, function(index, value) {
				data.push($(value).data());
			});
			return data;
		},

		// collapses open folders
		collapse : function() {
			var cacheItems = this.options.cacheItems;

			// find open folders
			this.$element.find('.' + $.trim(this.options['open-icon'].replace(/(\s+)/g, '.'))).each(function() {// ACE
				// update icon class
				var $this = $(this).removeClass(this.options['open-icon'] + ' ' + this.options['close-icon']).addClass(this.options['close-icon']);

				// "close" or empty folder contents
				var $parent = $this.parent().parent();
				var $folder = $parent.children('.tree-branch-children');

				$folder.addClass('hide');
				if (!cacheItems) {
					$folder.empty();
				}
			});
		},

		discloseFolder : function(el) {
			var $el = $(el);

			var $branch = $el.closest('.tree-branch');
			var $treeFolderContent = $branch.find('.tree-branch-children');
			var $treeFolderContentFirstChild = $treeFolderContent.eq(0);

			// take care of the styles
			$branch.addClass('tree-open');
			$branch.attr('aria-expanded', 'true');
			$treeFolderContentFirstChild.removeClass('hide hidden'); // hide is deprecated
			$branch.find('> .tree-branch-header .icon-folder').eq(0).removeClass('glyphicon-folder-close').addClass('glyphicon-folder-open');

			// add the children to the folder
			if (!$treeFolderContent.children().length) {
				this.populate($treeFolderContent);
			}

			this.$element.trigger('disclosedFolder.fu.tree', $branch.data());
		},

		// disclose visible will only disclose visible tree folders
		discloseVisible : function() {
			var self = this;

			var $openableFolders = self.$element.find(".tree-branch:not('.tree-open, .hidden, .hide')");
			var reportedOpened = [];

			var openReported = function openReported(event, opened) {
				reportedOpened.push(opened);

				if (reportedOpened.length === $openableFolders.length) {
					self.$element.trigger('disclosedVisible.fu.tree', {
						tree : self.$element,
						reportedOpened : reportedOpened
					});
					/*
					 * Unbind the `openReported` event. `discloseAll` may be running and we want to reset this method for the next iteration.
					 */
					self.$element.off('loaded.fu.tree', self.$element, openReported);
				}
			};

			// trigger callback when all folders have reported opened
			self.$element.on('loaded.fu.tree', openReported);

			// open all visible folders
			self.$element.find(".tree-branch:not('.tree-open, .hidden, .hide')").each(function triggerOpen() {
				self.discloseFolder($(this).find('.tree-branch-header'));
			});
		},

		/**
		 * Disclose all will keep listening for `loaded.fu.tree` and if `$(tree-el).data('ignore-disclosures-limit')` is `true` (defaults to `true`) it will attempt to disclose any new closed folders than were loaded in
		 * during the last disclosure.
		 */
		discloseAll : function(el) {
			var self = this;

			// first time
			if (typeof self.$element.data('disclosures') === 'undefined') {
				self.$element.data('disclosures', 0);
			}

			var isExceededLimit = (self.options.disclosuresUpperLimit >= 1 && self.$element.data('disclosures') >= self.options.disclosuresUpperLimit);
			var isAllDisclosed = self.$element.find(".tree-branch:not('.tree-open, .hidden, .hide')").length === 0;

			if (!isAllDisclosed) {
				if (isExceededLimit) {
					self.$element.trigger('exceededDisclosuresLimit.fu.tree', {
						tree : self.$element,
						disclosures : self.$element.data('disclosures')
					});

					/*
					 * If you've exceeded the limit, the loop will be killed unless you explicitly ignore the limit and start the loop again: $tree.one('exceededDisclosuresLimit.fu.tree', function () {
					 * $tree.data('ignore-disclosures-limit', true); $tree.tree('discloseAll'); });
					 */
					if (!self.$element.data('ignore-disclosures-limit')) {
						return;
					}

				}

				self.$element.data('disclosures', self.$element.data('disclosures') + 1);

				/*
				 * A new branch that is closed might be loaded in, make sure those get handled too. This attachment needs to occur before calling `discloseVisible` to make sure that if the execution of `discloseVisible`
				 * happens _super fast_ (as it does in our QUnit tests this will still be called. However, make sure this only gets called _once_, because otherwise, every single time we go through this loop, _another_
				 * event will be bound and then when the trigger happens, this will fire N times, where N equals the number of recursive `discloseAll` executions (instead of just one)
				 */
				self.$element.one('disclosedVisible.fu.tree', function() {
					self.discloseAll();
				});

				/*
				 * If the page is very fast, calling this first will cause `disclosedVisible.fu.tree` to not be bound in time to be called, so, we need to call this last so that the things bound and triggered above can
				 * have time to take place before the next execution of the `discloseAll` method.
				 */
				self.discloseVisible();
			} else {
				self.$element.trigger('disclosedAll.fu.tree', {
					tree : self.$element,
					disclosures : self.$element.data('disclosures')
				});

				// if `cacheItems` is false, and they call closeAll, the data is trashed and therefore
				// disclosures needs to accurately reflect that
				if (!self.options.cacheItems) {
					self.$element.one('closeAll.fu.tree', function() {
						self.$element.data('disclosures', 0);
					});
				}

			}

			// $('.tree-branch-name > i').removeClass('icon-folder ace-icon tree-plus glyphicon-folder-open').addClass('icon-folder glyphicon-folder-open ace-icon tree-minus');
			// $('.tree-branch-header').removeClass('tree-branch-header').addClass('tree-item');
			// $('.tree-branch-name').removeClass('tree-branch-name').addClass('tree-item-name');
			// $('.tree-item-name > i').removeClass('icon-folder ace-icon tree-plus glyphicon-folder-open').addClass('icon-item ace-icon fa fa-times');
			// $('.tree-branch-name > i').removeClass('icon-folder ace-icon tree-plus glyphicon-folder-open').css("color: #F9E8CE;width: 13px;height: 13px;line-height: 13px;font-size: 11px;text-align: center;border-radius: 3px;-webkit-box-sizing: content-box;-moz-box-sizing: content-box;box-sizing: content-box;background-color: #FAFAFA;border: 1px solid #CCC;box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);");

			// console.log($('.tree-branch-name'));
		}
	};

	// TREE PLUGIN DEFINITION

	$.fn.tree = function(option) {
		var args = Array.prototype.slice.call(arguments, 1);
		var methodReturn;

		var $set = this.each(function() {
			var $this = $(this);
			var data = $this.data('fu.tree');
			var options = typeof option === 'object' && option;

			if (!data)
				$this.data('fu.tree', (data = new Tree(this, options)));
			if (typeof option === 'string')
				methodReturn = data[option].apply(data, args);
		});

		return (methodReturn === undefined) ? $set : methodReturn;
	};

	$.fn.tree.defaults = {
		dataSource : function(options, callback) {
		},
		multiSelect : true,
		cacheItems : false,
		folderSelect : true
	// ACE
	};

	$.fn.tree.Constructor = Tree;

	$.fn.tree.noConflict = function() {
		$.fn.tree = old;
		return this;
	};

	// NO DATA-API DUE TO NEED OF DATA-SOURCE

	// -- BEGIN UMD WRAPPER AFTERWORD --
}));
// -- END UMD WRAPPER AFTERWORD --
