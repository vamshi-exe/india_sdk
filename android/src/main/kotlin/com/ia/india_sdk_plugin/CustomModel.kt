package com.example.india_sdk

import com.ia.india_sdk_plugin.IndiaDelegate

class CustomModel private constructor() {

    interface OnCustomStateListener {
        fun stateChanged()
    }

    private var mListener: OnCustomStateListener? = null
    private var mState: Boolean = false

    fun setListener(listener: IndiaDelegate) {
        mListener = listener
    }

    fun changeState(state: Boolean) {
        mState = state
        mListener?.let {
            notifyStateChange()
        }
    }

    fun getState(): Boolean {
        return mState
    }

    private fun notifyStateChange() {
        mListener?.stateChanged()
    }

    companion object {
        @Volatile
        private var mInstance: CustomModel? = null

        fun getInstance(): CustomModel {
            return mInstance ?: synchronized(this) {
                mInstance ?: CustomModel().also { mInstance = it }
            }
        }
    }
}
