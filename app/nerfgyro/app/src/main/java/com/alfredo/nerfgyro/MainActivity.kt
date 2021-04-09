package com.alfredo.nerfgyro

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.TextView

class MainActivity : AppCompatActivity(), SensorEventListener {
    private lateinit var mSensorManager : SensorManager
    private var mAccelerometer : Sensor ?= null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        mSensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_FASTEST)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        return
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event != null) {
            if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {

                var mx = event.values[0].toString()
                var my = event.values[1].toString()
                var mz = event.values[2].toString()

                var mAccData = "$mx, $my, $mz"
                findViewById<TextView>(R.id.gyroData).text = mAccData

                Log.v("nerfgyro", mAccData)
            }
        }
    }
}