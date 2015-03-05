package ru.ganzin.utils.bitmap
{
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;

    public class BitmapSprite
    {
        private const _origin:Point = new Point();

        public function BitmapSprite(spriteSet:BitmapData, totalFrames:int = 1, frameBufferScale:Number = 1,
                                     isPivotTopLeft:Boolean = false, transparent:Boolean = true)
        {
            _colorTransform = new ColorTransform();
            _spriteSet = spriteSet;
            _totalFrames = totalFrames;
            _frameBufferScale = frameBufferScale;
            _isPivotTopLeft = isPivotTopLeft;
            _transparent = transparent;
            _frameSize = new Point(spriteSet.width / _totalFrames, spriteSet.height);
            _clipRect = new Rectangle(0, 0, _frameSize.x, _frameSize.y);
            setupFrameBuffer();

            super();
        }

        public var endFrameSignal:Signal0 = new Signal0();

        private var _scratch:BitmapData;
        private var _blendMode:String;
        private var _clipRect:Rectangle;
        private var _colorTransform:ColorTransform;

        private var _destPoint:Point = new Point();

        private var _frameAnimator:Number = 0;
        private var _frameBuffer:BitmapData;
        private var _frameBufferOffset:Point;
        private var _frameBufferRect:Rectangle;
        private var _frameBufferScale:Number;

        private var _isHiding:Boolean;
        private var _isPivotTopLeft:Boolean;

        private var _isToBeRemoved:Boolean;
        private var _needToUpdateFrameBuffer:Boolean;
        private var _offsetX:Number = 0;
        private var _offsetY:Number = 0;
        private var _spriteSet:BitmapData;
        private var _transform:Matrix = new Matrix();
        private var _transparent:Boolean;

        private var _alpha:Number = 1;

        public function get alpha():Number
        {
            return _alpha;
        }

        public function set alpha(value:Number):void
        {
            _alpha = value;
        }

        private var _currentFrame:int;

        public function get currentFrame():int
        {
            return _currentFrame;
        }

        private var _hideOnStop:Boolean;

        public function set hideOnStop(value:Boolean):void
        {
            _hideOnStop = value;
        }

        private var _removeAtEnd:Boolean;

        public function set removeAtEnd(value:Boolean):void
        {
            _removeAtEnd = value;
        }

        private var _rotation:Number = 0;

        public function get rotation():Number
        {
            return _rotation;
        }

        public function set rotation(value:Number):void
        {
            if (value === _rotation) return;

            _rotation = value;
            _needToUpdateFrameBuffer = true;
        }

        private var _scaleX:Number = 1;

        public function get scaleX():Number
        {
            return _scaleX;
        }

        public function set scaleX(value:Number):void
        {
            _scaleX = value;
        }

        private var _scaleY:Number = 1;

        public function get scaleY():Number
        {
            return _scaleY;
        }

        public function set scaleY(value:Number):void
        {
            _scaleY = value;
        }

        private var _smoothing:Boolean = false;

        public function set smoothing(value:Boolean):void
        {
            _smoothing = value;
        }

        private var _totalFrames:int;

        public function get totalFrames():int
        {
            return _totalFrames;
        }

        private var _visible:Boolean = true;

        public function get visible():Boolean
        {
            return _visible && _alpha > 0;
        }

        public function set visible(value:Boolean):void
        {
            _visible = value;
        }

        private var _x:Number = 0;

        public function get x():Number
        {
            return _x;
        }

        public function set x(value:Number):void
        {
            _x = isNaN(value) ? 0 : value;
        }

        private var _y:Number = 0;

        public function get y():Number
        {
            return _y;
        }

        public function set y(value:Number):void
        {
            _y = isNaN(value) ? 0 : value;
        }

        private var _fps:int = 25;

        public function get fps():int
        {
            return _fps;
        }

        public function set fps(value:int):void
        {
            _fps = value;
        }

        private var _frameSize:Point;

        public function get height():Number
        {
            return _frameSize.y;
        }

        public function get width():Number
        {
            return _frameSize.x;
        }

        private var _decals:Vector.<BitmapSprite>;

        public function addDecal(value:BitmapSprite):void
        {
            if (_decals == null) _decals = new Vector.<BitmapSprite>;
            _decals.push(value);
            _needToUpdateFrameBuffer = true;
        }

        private var _filters:Vector.<BitmapFilter>;

        public function applyFilter(value:BitmapFilter):void
        {
            _filters = new <BitmapFilter>[value];
            applyFilters(_filters);
        }

        public function applyFilters(value:Vector.<BitmapFilter>):void
        {
            if (_filters == null) _filters = new <BitmapFilter>[];
            _filters = _filters.concat(value);
            _needToUpdateFrameBuffer = true;
        }

        public function clearDecals():void
        {
            if (_decals != null) _decals.length = 0;
        }

        public function clearFilters():void
        {
            if (_filters != null) _filters.length = 0;
        }

        private var _isPlaying:Boolean;

        public function isPlaying():Boolean
        {
            return _isPlaying;
        }

        private var _isRepeating:Boolean;

        public function isRepeating():Boolean
        {
            return _isRepeating;
        }

        public function isToBeRemoved():Boolean
        {
            return _isToBeRemoved;
        }

        public function play(loop:Boolean = false):void
        {
            _isRepeating = loop;
            _isPlaying = true;
            _isHiding = false;
            _frameAnimator = _currentFrame;
        }

        public function render(x:Number, y:Number, bd:BitmapData):void
        {
            if (_isToBeRemoved) return;
            if (_currentFrame < 0) return;
            if (!_visible) return;
            if (_alpha <= 0) return;
            if (_isHiding) return;
            if (_needToUpdateFrameBuffer) updateFrameBuffer();

            var tx:int = x + _x;
            var ty:int = y + _y;

            if (_alpha < 1 || _scaleX !== 1 || _scaleY !== 1 || _rotation !== 0 || _blendMode != null)
            {
                _transform.identity();
                _transform.tx = _offsetX;
                _transform.ty = _offsetY;
                _transform.scale(_scaleX, _scaleY);

                if (_rotation !== 0) _transform.rotate(_rotation);

                _transform.translate(tx, ty);
                _colorTransform.alphaMultiplier = _alpha;

                bd.draw(_frameBuffer, _transform, _colorTransform, _blendMode, null, _smoothing);
            }
            else
            {
                _destPoint.x = int(tx + _offsetX);
                _destPoint.y = int(ty + _offsetY);
                bd.copyPixels(_frameBuffer, _frameBufferRect, _destPoint, null, null, _transparent);
            }
        }

        public function renderColorized(x:Number, y:Number, bd:BitmapData, colorMatrixFilter:ColorMatrixFilter):void
        {
            if (_isToBeRemoved) return;
            if (_currentFrame < 0)  return;
            if (!_visible)  return;
            if (_alpha <= 0)  return;
            if (_isHiding)  return;
            if (_needToUpdateFrameBuffer) updateFrameBuffer();

            var tx:Number = x + _x;
            var ty:Number = y + _y;

            _transform.identity();
            _transform.tx = _offsetX;
            _transform.ty = _offsetY;
            _transform.scale(_scaleX, _scaleY);

            if (_rotation !== 0) _transform.rotate(_rotation);

            _colorTransform.alphaMultiplier = _alpha;

            _scratch.fillRect(_frameBufferRect, 4095);
            _scratch.copyPixels(_spriteSet, _clipRect, new Point(), null, null, false);
            _transform.translate(int(tx), int(ty));
            bd.draw(_frameBuffer, _transform, _colorTransform, _blendMode, null, _smoothing);
            _scratch.applyFilter(_scratch, new Rectangle(0, 0, _scratch.width, _scratch.height), new Point(0, 0), colorMatrixFilter);
            bd.draw(_scratch, _transform, null, BlendMode.OVERLAY, null, false);
        }

        public function setBlendMode(value:String):void
        {
            _blendMode = value;
        }

        public function setFrame(value:int):void
        {
            if (value === _currentFrame) return;

            _currentFrame = value;
            _clipRect.x = value * _frameSize.x;
            _needToUpdateFrameBuffer = true;
        }

        public function stop():void
        {
            if (_hideOnStop) _isHiding = true;
            _isPlaying = false;
        }

        public function tick(value:Number):void
        {
            if (_isToBeRemoved) return;
            if (!_isPlaying) return;

            _frameAnimator = _frameAnimator + _fps * value;

            if (_frameAnimator > (_totalFrames - 1))
            {
                if (_isRepeating)
                {
                    _frameAnimator = _frameAnimator % _totalFrames;
                }
                else
                {
                    _frameAnimator = _totalFrames - 1;
                    stop();
                    if (_removeAtEnd) _isToBeRemoved = true;
                }

                endFrameSignal.dispatch();
            }

            setFrame(int(_frameAnimator));
        }

        private function setupFrameBuffer():void
        {
            _frameBuffer = new BitmapData(_frameSize.x * _frameBufferScale, _frameSize.y * _frameBufferScale, _transparent, 0);
            _frameBufferRect = new Rectangle(0, 0, _frameBuffer.width, _frameBuffer.height);

            if (!_isPivotTopLeft)
            {
                _offsetX = (-_frameBufferRect.width) * 0.5;
                _offsetY = (-_frameBufferRect.height) * 0.5;
            }
            _frameBufferOffset = new Point(Math.floor((_frameBuffer.width - _frameSize.x) * 0.5),
                    Math.floor((_frameBuffer.height - _frameSize.y) * 0.5));

            _scratch = new BitmapData(_frameBuffer.width, _frameBuffer.height, true, 0xFFFFFF);
            _needToUpdateFrameBuffer = true;
        }

        private function updateFrameBuffer():void
        {
            _frameBuffer.fillRect(_frameBufferRect, 0xFFFFFF);
            _frameBuffer.copyPixels(_spriteSet, _clipRect, _frameBufferOffset, null, null, _transparent);

            for each (var sprite:BitmapSprite in _decals)
                sprite.render(0, 0, _frameBuffer);

            for each (var filter:BitmapFilter in _filters)
                _frameBuffer.applyFilter(_frameBuffer, _frameBufferRect, _origin, filter);

            _needToUpdateFrameBuffer = false;
        }

    }
}
