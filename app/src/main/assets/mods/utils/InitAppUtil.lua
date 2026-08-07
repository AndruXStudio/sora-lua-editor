local SDK_INT = luajava.bindClass "android.os.Build".VERSION.SDK_INT


if this.getSharedData("editor_magnify") == nil
  if SDK_INT >= 28 then
    this.setSharedData("editor_magnify", true)
   else
    this.setSharedData("editor_magnify", false)
  end
end

if this.getSharedData("custom_symbol_bar") == nil

  this.setSharedData("custom_symbol_bar", [[Fun() ( ) [ ] { } " = : . , ; _ + - * / \ % # ^ $ ? & | < > ~ ']])

end

if this.getSharedData("custom_syntax_highlighting") == nil

  this.setSharedData("custom_syntax_highlighting", [[class
public
_M
super
meta
static
extends
__init]])

end

if this.getSharedData("compileLua") == nil

  this.setSharedData("compileLua", true)

end

if this.getSharedData("editor_completing_box") == nil

  this.setSharedData("editor_completing_box", true)

end

if this.getSharedData("editor_code_parser") == nil

  this.setSharedData("editor_code_parser", true)

end

if this.getSharedData("slide_hide") == nil

  this.setSharedData("slide_hide", true)

end

if this.getSharedData("check_error") == nil

  this.setSharedData("check_error", true)

end

if this.getSharedData("editor_symbolBar") == nil

  this.setSharedData("editor_symbolBar", true)

end

if this.getSharedData("code_save_exception_detection") == nil

  this.setSharedData("code_save_exception_detection", true)

end

if this.getSharedData("theme_light_dark") == nil

  this.setSharedData("theme_light_dark", 1)

end

if this.getSharedData("item_list_columns") == nil

  this.setSharedData("item_list_columns", 1)

end

if this.getSharedData("theme_color") == nil

  this.setSharedData("theme_color", 1)

end

if this.getSharedData("layouthelper_dialog") == nil

  this.setSharedData("layouthelper_dialog", 1)

end

if this.getSharedData("signature_scheme") == nil

  this.setSharedData("signature_scheme", 1)

end

if this.getSharedData("global_font_size") == nil

  this.setSharedData("global_font_size", 2)

end

if not this.getSharedData("keyword_color")

  this.setSharedData("keyword_color", 0xFF36618E)

end

if not this.getSharedData("userword_color")

  this.setSharedData("userword_color", 0xFFD32F2F)

end

if not this.getSharedData("baseword_color")

  this.setSharedData("baseword_color", 0xFF1976D2)

end

if not this.getSharedData("string_color")

  this.setSharedData("string_color", 0xFFC2185B)

end

if not this.getSharedData("comment_color")

  this.setSharedData("comment_color", 0xFF73777F)

end