package com.aocyun.chuangrtcdemo.views

import android.content.Context
import android.content.res.TypedArray
import android.graphics.*
import android.util.AttributeSet
import android.util.Log
import android.widget.FrameLayout
import androidx.annotation.ColorInt
import com.aocyun.chuangrtcdemo.R

open class RoundedView : FrameLayout {
    private var topLeftCornerRadius = 0f
    private var topRightCornerRadius = 0f
    private var bottomLeftCornerRadius = 0f
    private var bottomRightCornerRadius = 0f
    private var cornerRadius = 0f
    private var viewBound: RectF? = null
    private var roundPath = Path()
    private var dispatchDrawWithoutClip: Boolean = true
    private lateinit var paint: Paint
    private var borderWidth = -1.0f
        set(value) { field = value; postInvalidate() }
    @ColorInt var borderColor: Int = Color.TRANSPARENT
        set(value) { field = value; postInvalidate() }

    constructor(context: Context) : super(context) { initialize(context) }
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) { initialize(context, attrs) }
    constructor(context: Context, attrs: AttributeSet, defStyleAttr: Int) : super(context, attrs, defStyleAttr) { initialize(context, attrs) }

    private fun initialize(context: Context, attrs: AttributeSet? = null) {
        paint = Paint()
        val typedArray: TypedArray = context.theme.obtainStyledAttributes(attrs, R.styleable.RoundedView, 0, 0)
        cornerRadius = typedArray.getDimension(R.styleable.RoundedView_roundedViewCornerRadius, 0f)
        topLeftCornerRadius = if (cornerRadius > 0) cornerRadius else typedArray.getDimension(R.styleable.RoundedView_topLeftCornerRadius, 0f)
        topRightCornerRadius = if (cornerRadius > 0) cornerRadius else typedArray.getDimension(R.styleable.RoundedView_topRightCornerRadius, 0f)
        bottomLeftCornerRadius = if (cornerRadius > 0) cornerRadius else typedArray.getDimension(R.styleable.RoundedView_bottomLeftCornerRadius, 0f)
        bottomRightCornerRadius = if (cornerRadius > 0) cornerRadius else typedArray.getDimension(R.styleable.RoundedView_bottomRightCornerRadius, 0f)
        borderWidth = typedArray.getDimension(R.styleable.RoundedView_borderWidth, -1.0f)
        borderColor = typedArray.getColor(R.styleable.RoundedView_borderColor, Color.TRANSPARENT)
        dispatchDrawWithoutClip = typedArray.getBoolean(R.styleable.RoundedView_dispatchDrawWithoutClip, true)
        typedArray.recycle()
    }

    override fun onSizeChanged(width: Int, height: Int, oldWidth: Int, oldHeight: Int) {
        super.onSizeChanged(width, height, oldWidth, oldHeight)
        viewBound = RectF(paddingLeft.toFloat(), paddingTop.toFloat(), width.toFloat() - paddingLeft - paddingRight, height.toFloat() - paddingTop - paddingBottom)
        resetPath()
    }

    override fun dispatchDraw(canvas: Canvas?) {
        if (!dispatchDrawWithoutClip) {
            super.dispatchDraw(canvas)
        } else {
            try {
                val save = canvas!!.save()
                canvas.clipPath(roundPath)
                super.dispatchDraw(canvas)
                canvas.restoreToCount(save)
            } catch (e: Exception) {
                Log.e(RoundedView::class.toString(), "${e.message}")
            }
        }
        if (borderWidth > 0f) {
            paint.isAntiAlias = true
            paint.color = borderColor
            paint.style = Paint.Style.STROKE
            paint.strokeWidth = borderWidth
            canvas?.drawPath(roundPath, paint)
        }
    }

    override fun draw(canvas: Canvas?) {
        val save = canvas!!.save()
        canvas.clipPath(roundPath)
        super.draw(canvas)
        canvas.restoreToCount(save)
    }

    private fun resetPath() {
        roundPath.reset()
        val cornerDimensions = floatArrayOf(
            topLeftCornerRadius,
            topLeftCornerRadius,
            topRightCornerRadius,
            topRightCornerRadius,
            bottomRightCornerRadius,
            bottomRightCornerRadius,
            bottomLeftCornerRadius,
            bottomLeftCornerRadius
        )
        roundPath.addRoundRect(viewBound ?: RectF(), cornerDimensions, Path.Direction.CW)
        roundPath.close()
    }
}
