function VideoCube (cubeIdorClass, width) {
    var $cubeHolder = $(cubeIdorClass);

    var WIDTH = 320;
    var HEIGHT = 240;
    var OFFSETX = 10;
    var OFFSETY = 10;
    var SPACINGX = -6;
    var SPACINGY = -10;

    var Z_OFFSET = 500;
    var Z_SPACE = 1;

    var Type_Item = {
        itemId: '',
        $dom: null,
        $info: null,
        pos: -1,
        x: 0,
        y: 0,
        z: 0,
        w: 0,
        h: 0,
        ow: null,
        oh: null,
    }
    /**
     * @type Array<Type_Item>
     */
    var itemQueue = [];
    var templ = '';

    /**
     * @param {Type_Item} _item 
     */
    function reduceAbove (_item) {
        var __item;
        for (var i = 0, l = itemQueue.length; i < l; i++) {
            __item = itemQueue[i];
            if (__item.z > _item.z) {
                __item.z -= 1;
                __item.$dom.css({ "z-index": Z_OFFSET + __item.z * Z_SPACE });
            }
        }
    }

    function getItem (itemId) {
        for (var i = 0, l = itemQueue.length; i < l; i++) {
            if (itemQueue[i].itemId == itemId)
                return itemQueue[i];
        }
        return null;
    }

    /**
     * @param {Type_Item} _item 
     * @param {number} posDef 
     */
    function moveItem (_item, myPos, x, y, z) {
        _item.pos = myPos,
            _item.x = x,
            _item.y = y,
            _item.z = z;

        var $dom = _item.$dom;
        $dom.css({ "left": x, "top": y, "z-index": Z_OFFSET + z * Z_SPACE });//.width(posDef.w).height(posDef.h);

        // $dom.draggable("disable" );
    }

    /**
     * 自动缩放，以便于不过大过小
     * @param {Type_Item} _item 
     */
    function autoScale (_item) {
        var ow = _item.ow, oh = _item.oh;
        if (!ow || !oh) {
            return _item.w = WIDTH, _item.h = HEIGHT, void 0;
        }

        ow = parseInt(_item.ow), oh = parseInt(_item.oh);
        var w, h;
        if (ow >= oh) {
            if (ow * 3 >= oh * 4) { // 宽向
                w = WIDTH;
                h = Math.floor(WIDTH * oh / ow);
            } else {
                h = HEIGHT;
                w = Math.floor(HEIGHT * ow / oh);
            }
        } else {
            if (ow * 4 >= oh * 3) {// 竖向
                w = HEIGHT;
                h = Math.floor(HEIGHT * oh / ow);
            } else {
                h = WIDTH;
                w = Math.floor(WIDTH * ow / oh);
            }
        }

        _item.w = w, _item.h = h;
    }


    var cube = {
        setItemTpl: function (tpl) {
            templ = tpl;
        },

        resize: function () {
            // 重设 WIDTH，HEIGHT，DEF_POS 以适应新的宽度
            var cubeWidth = $cubeHolder.width();
            // console.log(cubeWidth);
            if (cubeWidth >= 960) {
                $cubeHolder.height(Math.ceil(cubeWidth * 9 / 16));
                // 1280 & 960
                if (cubeWidth == 1280) {
                    WIDTH = 220, HEIGHT = 140, OFFSETX = 10, OFFSETY = 10, SPACINGX = -6, SPACINGY = -16;
                } else if (cubeWidth == 960) {
                    WIDTH = 240, HEIGHT = 160, OFFSETX = 10, OFFSETY = 10, SPACINGX = -6, SPACINGY = 10;
                } else {
                    throw new Error('unsupport resolution.');
                }
            } else if (cubeWidth >= 360) {
                $cubeHolder.height(Math.ceil(cubeWidth * 16 / 9));
                // 720 & 540
                if (cubeWidth == 720) {
                    WIDTH = 240, HEIGHT = 320, OFFSETX = 10, OFFSETY = 10, SPACINGX = -10, SPACINGY = -16;
                } else if (cubeWidth == 540) {
                    WIDTH = 160, HEIGHT = 240, OFFSETX = 10, OFFSETY = 10, SPACINGX = 16, SPACINGY = -16;
                } else if (cubeWidth == 360) {
                    WIDTH = 128, HEIGHT = 160, OFFSETX = 4, OFFSETY = 4, SPACINGX = -16, SPACINGY = -16;
                }
            }
        },

        addItem: function (itemId, width, height) {

            /**
             * @type {Type_Item}
             */
            var _item;
            for (var i = 0, l = itemQueue.length; i < l; i++) {
                _item = itemQueue[i];
                if (_item.itemId == itemId) {
                    console.log('itemId duplicated.'); return false;
                }
            }

            var $itemDom = $(templ.replace(/__k__/g, itemId));
            var $itemInfo = $itemDom.find('.stream-info pre');
            var $streamName = $itemDom.find('.userid input');

            $cubeHolder.append($itemDom);

            _item = { itemId: itemId, $dom: $itemDom, $value: $streamName, $info: $itemInfo, ow: width, oh: height };
            autoScale(_item);

            itemQueue.push(_item);

            return _item.$dom;
        },

        setItemInfo: function (itemId, text) {
            var _item, i, l;
            for (i = 0, l = itemQueue.length; i < l; i++) {
                if (itemQueue[i].itemId == itemId) {
                    _item = itemQueue[i];
                    _item.$info.html(text);
                    break;
                }
            }
        },

        setStreamValue: function (itemId, text) {
            var _item, i, l;
            for (i = 0, l = itemQueue.length; i < l; i++) {
                if (itemQueue[i].itemId == itemId) {
                    _item = itemQueue[i];
                    _item.$value.val(text);
                    break;
                }
            }
        },

        removeItem: function (itemId) {
            // console.log('remove item ', itemId);

            var _item, i, l;
            for (i = 0, l = itemQueue.length; i < l; i++) {
                if (itemQueue[i].itemId == itemId) {
                    _item = itemQueue[i];
                    // 移除对应的dom
                    _item.$dom.remove();
                    itemQueue.splice(i, 1); l--;
                    break;
                }
            }

            if (!_item) return false;

            // i == 0 时，需要从队列首转移一个到主位
            if (i == 0) {
                if (l > 0) {
                    _item = itemQueue[0];

                    reduceAbove(_item);
                    // 移动位置
                    moveItem(_item, 0, 0, 0, 0);
                }
            }
            else {
                // 将zIndex大于_item的全部向下一层
                reduceAbove(_item);
            }

            return true;
        },

        removeAll: function () {
            for (var i = 0, l = itemQueue.length, _item; i < l;) {
                _item = itemQueue[i];
                _item.$dom.remove();
                itemQueue.splice(i, 1); l--;
            }
        },

        getAllItemId: function () {
            var itemIds = [];
            for (var i = 0, l = itemQueue.length, _item; i < l; i++) {
                _item = itemQueue[i];
                itemIds.push(_item.itemId);
            }
            return itemIds;
        },
        getAllItems: function () {
            var ids = this.getAllItemId();
            var items = [];
            for (var i = 0; i < ids.length; i++) {
                items.push(getItem(ids[i]));

            }
            return items;
        },
    };

    return cube;
}