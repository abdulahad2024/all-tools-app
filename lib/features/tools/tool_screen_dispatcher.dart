import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/tool_categories.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/providers/history_provider.dart';

// Import all specific tool screen files
import 'calculator_math/math_tools/math_utils/math_utils.dart';
import 'pdf_document/pdf_tools_screen.dart';
import 'image_photo/image_tools_screen.dart';
import 'qr_barcode/qr_tools_screen.dart';
import 'developer/developer_tools_screen.dart';
import 'internet_network/network_tools_screen.dart';
import 'student_education/student_tools_screen.dart';
import 'daily_productivity/productivity_tools_screen.dart';
import 'measurement_conversion/conversion_tools_screen.dart';
import 'audio_video/media_tools_screen.dart';
import 'finance_business/finance_tools_screen.dart';
import 'text_ai/text_ai_screen.dart';
import 'security_privacy/security_tools_screen.dart';
import 'gps_location/gps_tools_screen.dart';
import 'file_storage/file_tools_screen.dart';
import 'mobile_device/device_tools_screen.dart';

class ToolScreenDispatcher {
  static void openTool(BuildContext context, WidgetRef ref, String toolId) {
    // Record tool in history
    ref.read(historyProvider.notifier).addToolToHistory(toolId);

    Widget screen;
    switch (toolId) {
      // 1. Calculator & Math
      case 'basic_calc':
      case 'scientific_calc':
        screen = tools[0].page(tools[0]);
        break;

      case 'age_calc':
        screen = tools[1].page(tools[1]);
        break;

      case 'date_diff_calc':
        screen = tools[2].page(tools[2]);
        break;

      case 'percentage_calc':
      case 'discount_calc':
        screen = tools[3].page(tools[3]);
        break;

      case 'profit_loss_calc':
        screen = tools[4].page(tools[4]);
        break;

      case 'emi_calc':
        screen = tools[5].page(tools[5]);
        break;

      case 'bmi_calc':
      case 'bmr_calc':
        screen = tools[6].page(tools[6]);
        break;

      case 'gpa_calc':
        screen = tools[7].page(tools[7]);
        break;

      case 'fraction_calc':
        screen = tools[8].page(tools[8]);
        break;

      case 'ratio_calc':
        screen = tools[9].page(tools[9]);
        break;

      case 'average_calc':
        screen = tools[10].page(tools[10]);
        break;

      case 'unit_converter_math':
        screen = tools[11].page(tools[11]);
        break;

      case 'number_system_converter':
        screen = tools[12].page(tools[12]);
        break;

      case 'equation_solver':
        screen = tools[13].page(tools[13]);
        break;

      case 'random_generator':
        screen = tools[14].page(tools[14]);
        break;

      case 'prime_checker':
        screen = tools[15].page(tools[15]);
        break;

      case 'factorial_calc':
        screen = tools[16].page(tools[16]);
        break;

      // 2. PDF & Document
      case 'image_to_pdf':
      case 'photo_to_pdf':
        screen = const ImageToPdfScreen();
        break;

      case 'pdf_merger':
        screen = const PdfMergeSplitScreen(isMergeMode: true);
        break;

      case 'pdf_splitter':
      case 'pdf_page_rotator':
      case 'pdf_page_reorder':
        screen = const PdfMergeSplitScreen(isMergeMode: false);
        break;

      case 'pdf_compressor':
        screen = const PdfCompressWatermarkScreen(mode: 'compress');
        break;

      case 'pdf_lock_unlock':
        screen = const PdfCompressWatermarkScreen(mode: 'lock');
        break;

      case 'watermark_pdf':
        screen = const PdfCompressWatermarkScreen(mode: 'watermark');
        break;

      case 'signature_maker':
        screen = const SignatureMakerScreen();
        break;

      case 'ocr_text':
      case 'pdf_text_extractor':
        screen = const TextExtractorScreen();
        break;

      case 'id_card_scanner':
      case 'doc_scanner':
      case 'qr_to_pdf':
        screen = const IdCardScannerScreen();
        break;

      case 'pdf_metadata_viewer':
      case 'pdf_page_counter':
      case 'pdf_reader':
      case 'pdf_to_image':
        screen = const PdfMetadataScreen();
        break;

      case 'word_to_pdf':
      case 'doc_converter':
        screen = const WordDocConverterScreen();
        break;

      // 3. Image & Photo
      case 'color_picker':
        screen = const ColorPickerScreen();
        break;

      case 'image_compressor':
      case 'image_resizer':
      case 'image_cropper':
      case 'image_rotator':
      case 'format_converter':
      case 'jpg_to_png':
      case 'png_to_jpg':
      case 'webp_converter':
      case 'bg_remover':
        screen = const ImageResizerCompressorScreen();
        break;

      case 'passport_photo_maker':
      case 'nid_photo_resizer':
        screen = const PassportNidPhotoScreen();
        break;

      case 'photo_filters':
      case 'blur_image':
      case 'pixelate_image':
      case 'image_watermark':
      case 'collage_maker':
      case 'meme_generator':
      case 'screenshot_editor':
        screen = const PhotoFiltersEditorScreen();
        break;

      case 'exif_viewer':
      case 'image_to_base64':
        screen = const ExifMetadataBase64Screen();
        break;

      // 4. QR & Barcode
      case 'qr_generator':
      case 'wifi_qr':
      case 'contact_qr':
      case 'url_qr':
      case 'text_qr':
      case 'payment_qr':
      case 'barcode_generator':
      case 'qr_exporter':
      case 'vcard_qr':
        screen = const QrGeneratorScreen();
        break;

      case 'qr_scanner':
      case 'barcode_scanner':
      case 'product_barcode':
      case 'qr_history':
        screen = const QrScannerScreen();
        break;

      // 5. Developer Tools
      case 'json_formatter':
      case 'json_validator':
      case 'json_minifier':
      case 'xml_formatter':
      case 'html_formatter':
      case 'css_minifier':
      case 'js_minifier':
      case 'sql_formatter':
        screen = const JsonFormatterScreen();
        break;

      case 'json_to_dart':
      case 'json_to_kotlin':
      case 'flutter_code_snippets':
      case 'dart_formatter':
        screen = const JsonToModelScreen();
        break;

      case 'base64_tool':
      case 'url_encoder':
      case 'jwt_decoder':
      case 'hash_generator':
      case 'uuid_generator':
      case 'regex_tester':
      case 'timestamp_converter':
      case 'color_code_converter':
      case 'css_gradient_generator':
      case 'box_shadow_generator':
      case 'lorem_generator':
      case 'markdown_previewer':
      case 'cron_helper':
      case 'http_status_codes':
      case 'api_tester':
      case 'git_cheat_sheet':
        screen = const HashGeneratorScreen();
        break;

      // 6. Internet & Network
      case 'speed_test':
      case 'ping_test':
      case 'net_monitor':
      case 'data_usage':
      case 'port_checker':
      case 'website_availability':
      case 'url_redirect':
      case 'ssl_checker':
        screen = const SpeedTestScreen();
        break;

      case 'public_ip':
      case 'ip_info':
      case 'wifi_details':
      case 'dns_lookup':
      case 'http_headers':
      case 'whois_lookup':
      case 'subnet_calc':
      case 'mac_formatter':
        screen = const IpViewerScreen();
        break;

      // 7. Student & Education
      case 'student_gpa':
      case 'student_cgpa':
      case 'attendance_calc':
      case 'study_timetable':
      case 'exam_countdown':
      case 'class_routine':
      case 'assignment_tracker':
        screen = const StudentGpaScreen();
        break;

      case 'word_counter':
      case 'character_counter':
      case 'reading_time_calc':
      case 'typing_test':
      case 'dictionary_tool':
      case 'physics_formulas':
      case 'study_notes':
      case 'flashcard_maker':
        screen = const WordCounterScreen();
        break;

      case 'pomodoro_timer':
        screen = const PomodoroTimerScreen();
        break;

      // 8. Daily Productivity
      case 'todo_list':
      case 'notes_app':
      case 'reminder_app':
      case 'habit_tracker':
      case 'bill_splitter':
      case 'decision_wheel':
      case 'text_case_converter':
      case 'text_repeater':
        screen = const TodoListScreen();
        break;

      case 'password_generator':
      case 'flashlight_tool':
      case 'stopwatch_timer':
      case 'world_clock':
        screen = const PasswordGeneratorScreen();
        break;

      // 9. Measurement & Conversion
      case 'unit_converter':
      case 'digital_ruler':
        screen = const UnitConverterScreen();
        break;

      case 'currency_converter':
        screen = const CurrencyConverterScreen();
        break;

      // 10. Audio & Video
      case 'voice_recorder':
      case 'media_metadata':
        screen = const VoiceRecorderScreen();
        break;

      // 11. Finance & Business
      case 'budget_calculator':
      case 'interest_calculator':
      case 'tax_vat_calculator':
      case 'invoice_generator':
        screen = const BudgetCalculatorScreen();
        break;

      // 12. Text & AI
      case 'bangla_unicode':
      case 'text_to_speech':
        screen = const BanglaUnicodeScreen();
        break;

      case 'ai_chat_assistant':
        screen = const AiAssistantScreen();
        break;

      // 13. Security
      case 'totp_authenticator':
      case 'secure_notes':
        screen = const TotpAuthenticatorScreen();
        break;

      // 14. GPS
      case 'gps_coordinates':
      case 'speedometer':
        screen = const GpsSpeedometerScreen();
        break;

      // 15. File
      case 'zip_extractor':
      case 'file_editor':
        screen = const FileEditorScreen();
        break;

      // 16. Device
      case 'device_info':
      case 'hardware_tester':
        screen = const DeviceSpecsScreen();
        break;

      default:
        final tool = ToolCategories.getToolById(toolId);
        final lang = ref.read(languageProvider);
        screen = Scaffold(
          appBar: AppBar(title: Text(tool.getTitle(lang))),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tool.icon, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  tool.getTitle(lang),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    tool.getDescription(lang),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Tool Initialized & Ready'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
