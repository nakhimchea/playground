// import 'package:wingbrain/core/flavor/app_config.dart';

class AssetPath {
  static String get basePath =>
      'assets'; //AppConfig.shared.isStandalone ? 'assets/images' : 'packages/wingchat/assets/wingchat';

  static String get localImageBasePath => '$basePath/images/';
}

/// Avoid assets with same names
enum AssetPathEnum {
  logo,
  wingBankSupportLogo,
  maintenance,
  refresh,
  wifiSlash,
  editPen,
  messageVoiceStart,
  messageVoiceStop,
  messageVoiceDelete,
  messageVoicePlay,
  messageVoicePause,
  messageVoiceRestart,
  verticalAttachment,
  messageSymbol,
  messageSeenCheck,
  messageSentCheck,
  send,
  phone,
  messageCopy,
  messageDownload,
  messageAttachmentDownload,
  messageCancel,
  messageRetry,
  messageCamera,
  messagePhoto,
  messageDocument,
  messageLocation,
  messageAttachmentFile,
  messageLocationMePin,
  messageLocationNotMePin,
  messageDeletedClose,
  messageSentError,
  messageRatingOne,
  messageRatingTwo,
  messageRatingThree,
  messageRatingFour,
  messageRatingFive,
  messageRatingOneDisabled,
  messageRatingTwoDisabled,
  messageRatingThreeDisabled,
  messageRatingFourDisabled,
  messageRatingFiveDisabled,
  settings,
  settingsCamera,
  settingsStorage,
  settingsMicrphone,
  settingsPhoto,
  assetException,
  messageCallIcon,
  callAgent,
  datePicker,
  informationCircle,
  phoneBlueBg,
  mail,
  alert,
  updateAlert,
  ;

  String get name {
    switch (this) {
      case AssetPathEnum.logo:
        return 'logo';
      case AssetPathEnum.wingBankSupportLogo:
        return 'wingbank_support_logo';
      case AssetPathEnum.maintenance:
        return 'maintenance';
      case AssetPathEnum.refresh:
        return 'refresh';
      case AssetPathEnum.editPen:
        return 'edit_pen';
      case AssetPathEnum.wifiSlash:
        return 'wifi_slash';
      case AssetPathEnum.messageVoiceStart:
        return 'message_voice_start';
      case AssetPathEnum.messageVoiceStop:
        return 'message_voice_stop';
      case AssetPathEnum.messageVoiceDelete:
        return 'message_voice_delete';
      case AssetPathEnum.messageVoicePlay:
        return 'message_voice_play';
      case AssetPathEnum.messageVoicePause:
        return 'message_voice_pause';
      case AssetPathEnum.messageVoiceRestart:
        return 'message_voice_restart';
      case AssetPathEnum.verticalAttachment:
        return 'vertical_attachment';
      case AssetPathEnum.messageSymbol:
        return 'message_symbol';
      case AssetPathEnum.messageSeenCheck:
        return 'message_seen_check';
      case AssetPathEnum.messageSentCheck:
        return 'message_sent_check';
      case AssetPathEnum.send:
        return 'send';
      case AssetPathEnum.phone:
        return 'phone';
      case AssetPathEnum.messageCopy:
        return 'message_copy';
      case AssetPathEnum.messageDownload:
        return 'message_download';
      case AssetPathEnum.messageAttachmentDownload:
        return 'message_attachment_download';
      case AssetPathEnum.messageCancel:
        return 'message_cancel';
      case AssetPathEnum.messageRetry:
        return 'message_retry';
      case AssetPathEnum.messageCamera:
        return 'message_camera';
      case AssetPathEnum.messagePhoto:
        return 'message_photo';
      case AssetPathEnum.messageDocument:
        return 'message_document';
      case AssetPathEnum.messageLocation:
        return 'message_location';
      case AssetPathEnum.messageAttachmentFile:
        return 'message_attachment_file';
      case AssetPathEnum.messageLocationMePin:
        return 'message_location_pin_me';
      case AssetPathEnum.messageLocationNotMePin:
        return 'message_location_pin_not_me';
      case AssetPathEnum.messageDeletedClose:
        return 'message_deleted_close';
      case AssetPathEnum.messageSentError:
        return 'message_sent_error';
      case AssetPathEnum.messageRatingOne:
        return 'message_rating_one';
      case AssetPathEnum.messageRatingTwo:
        return 'message_rating_two';
      case AssetPathEnum.messageRatingThree:
        return 'message_rating_three';
      case AssetPathEnum.messageRatingFour:
        return 'message_rating_four';
      case AssetPathEnum.messageRatingFive:
        return 'message_rating_five';
      case AssetPathEnum.messageRatingOneDisabled:
        return 'message_rating_one_disabled';
      case AssetPathEnum.messageRatingTwoDisabled:
        return 'message_rating_two_disabled';
      case AssetPathEnum.messageRatingThreeDisabled:
        return 'message_rating_three_disabled';
      case AssetPathEnum.messageRatingFourDisabled:
        return 'message_rating_four_disabled';
      case AssetPathEnum.messageRatingFiveDisabled:
        return 'message_rating_five_disabled';
      case AssetPathEnum.settings:
        return 'settings';
      case AssetPathEnum.settingsCamera:
        return 'settings_camera';
      case AssetPathEnum.settingsStorage:
        return 'settings_storage';
      case AssetPathEnum.settingsMicrphone:
        return 'settings_micrphone';
      case AssetPathEnum.settingsPhoto:
        return 'settings_photo';
      case AssetPathEnum.assetException:
        return 'alert_exception';
      case AssetPathEnum.messageCallIcon:
        return 'message_call_icon';
      case AssetPathEnum.callAgent:
        return 'call_agent';
      case AssetPathEnum.datePicker:
        return 'date_picker';
      case AssetPathEnum.informationCircle:
        return 'information_circle';
      case AssetPathEnum.phoneBlueBg:
        return 'phone_blue_bg';
      case AssetPathEnum.mail:
        return 'mail';
      case AssetPathEnum.alert:
        return 'alert';
      case AssetPathEnum.updateAlert:
        return 'update_alert';
    }
  }

  String get localPath {
    switch (this) {
      // PNG
      case AssetPathEnum.logo:
      case AssetPathEnum.wingBankSupportLogo:
      case AssetPathEnum.maintenance:
      case AssetPathEnum.refresh:
      case AssetPathEnum.editPen:
      case AssetPathEnum.wifiSlash:
      case AssetPathEnum.messageVoiceStart:
      case AssetPathEnum.messageVoiceStop:
      case AssetPathEnum.messageVoiceDelete:
      case AssetPathEnum.messageVoicePlay:
      case AssetPathEnum.messageVoicePause:
      case AssetPathEnum.messageVoiceRestart:
      case AssetPathEnum.verticalAttachment:
      case AssetPathEnum.messageSymbol:
      case AssetPathEnum.messageSeenCheck:
      case AssetPathEnum.messageSentCheck:
      case AssetPathEnum.send:
      case AssetPathEnum.phone:
      case AssetPathEnum.messageCopy:
      case AssetPathEnum.messageDownload:
      case AssetPathEnum.messageAttachmentDownload:
      case AssetPathEnum.messageCancel:
      case AssetPathEnum.messageRetry:
      case AssetPathEnum.messageCamera:
      case AssetPathEnum.messagePhoto:
      case AssetPathEnum.messageDocument:
      case AssetPathEnum.messageLocation:
      case AssetPathEnum.messageAttachmentFile:
      case AssetPathEnum.messageLocationMePin:
      case AssetPathEnum.messageLocationNotMePin:
      case AssetPathEnum.messageDeletedClose:
      case AssetPathEnum.messageSentError:
      case AssetPathEnum.messageRatingOne:
      case AssetPathEnum.messageRatingTwo:
      case AssetPathEnum.messageRatingThree:
      case AssetPathEnum.messageRatingFour:
      case AssetPathEnum.messageRatingFive:
      case AssetPathEnum.messageRatingOneDisabled:
      case AssetPathEnum.messageRatingTwoDisabled:
      case AssetPathEnum.messageRatingThreeDisabled:
      case AssetPathEnum.messageRatingFourDisabled:
      case AssetPathEnum.messageRatingFiveDisabled:
      case AssetPathEnum.settings:
      case AssetPathEnum.settingsCamera:
      case AssetPathEnum.settingsStorage:
      case AssetPathEnum.settingsMicrphone:
      case AssetPathEnum.settingsPhoto:
      case AssetPathEnum.assetException:
      case AssetPathEnum.messageCallIcon:
      case AssetPathEnum.callAgent:
      case AssetPathEnum.datePicker:
      case AssetPathEnum.informationCircle:
      case AssetPathEnum.phoneBlueBg:
      case AssetPathEnum.mail:
      case AssetPathEnum.alert:
      case AssetPathEnum.updateAlert:
        return '${AssetPath.localImageBasePath}$name.png';
    }
  }
}
