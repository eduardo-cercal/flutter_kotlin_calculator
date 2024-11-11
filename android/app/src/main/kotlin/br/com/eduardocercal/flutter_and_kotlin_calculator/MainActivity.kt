package br.com.eduardocercal.flutter_and_kotlin_calculator

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter_kotlin_calculator/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "calculate") {
                val arguments = call.argument<HashMap<String, Any>>("arguments")
                if (arguments != null) {
                    val nativeData = calculate(arguments)
                    result.success(nativeData)
                } else {
                    result.error("INVALID_ARGUMENTS", "Arguments cannot be null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun calculate(map: HashMap<String, Any>): String {
        val firstNumber = map["firstNumber"] as? Double ?: return "Invalid first number"
        val secondNumber = map["secondNumber"] as? Double ?: return "Invalid second number"
        val operation = map["operation"] as? String ?: return "Invalid operation"

        val result = when (operation) {
            "+" -> firstNumber + secondNumber
            "-" -> firstNumber - secondNumber
            "*" -> firstNumber * secondNumber
            "/" -> if (secondNumber != 0.0) firstNumber / secondNumber else "Cannot divide by zero"
            "%" -> firstNumber % secondNumber
            else -> "Invalid operation"
        }

        return "O resultado da operação $firstNumber $operation $secondNumber é: $result"
    }
}
