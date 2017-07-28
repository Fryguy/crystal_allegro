@[Link("allegro")]
@[Link("allegro_dialog")]
@[Link("allegro_font")]
@[Link("allegro_image")]
{% if flag?(:darwin) %}
  @[Link(ldflags: "-L`xcode-select --print-path`/usr/lib")]
  @[Link(ldflags: "-rpath `xcode-select --print-path`/usr/lib")]
{% else %}
  @[Link(ldflags: "`llvm-config-3.6 --ldflags 2>/dev/null || llvm-config-3.5 --ldflags 2>/dev/null || llvm-config --ldflags 2>/dev/null`")]
{% end %}
lib LibAllegro
  VERSION                     =                      5
  SUB_VERSION                 =                      2
  WIP_VERSION                 =                      2
  UNSTABLE_BIT                =                      0
  RELEASE_NUMBER              =                      1
  DATE                        =               20161211
  PI                          = 3.14159265358979323846
  NEW_WINDOW_TITLE_MAX_SIZE   =                    255
  MOUSE_MAX_EXTRA_AXES        =                      4
  TOUCH_INPUT_MAX_TOUCH_COUNT =                     16
  fun get_allegro_version = al_get_allegro_version : Uint32T
  alias Uint32T = LibC::UInt
  fun run_main = al_run_main(argc : LibC::Int, argv : LibC::Char**, x2 : (LibC::Int, LibC::Char** -> LibC::Int)) : LibC::Int

  struct Timeout
    __pad1__ : Uint64T
    __pad2__ : Uint64T
  end

  alias Uint64T = LibC::ULongLong
  fun get_time = al_get_time : LibC::Double
  fun rest = al_rest(seconds : LibC::Double)
  fun init_timeout = al_init_timeout(timeout : Timeout*, seconds : LibC::Double)

  struct Color
    r : LibC::Float
    g : LibC::Float
    b : LibC::Float
    a : LibC::Float
  end

  fun map_rgb = al_map_rgb(r : UInt8, g : UInt8, b : UInt8) : Color
  fun map_rgba = al_map_rgba(r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Color
  fun map_rgb_f = al_map_rgb_f(r : LibC::Float, g : LibC::Float, b : LibC::Float) : Color
  fun map_rgba_f = al_map_rgba_f(r : LibC::Float, g : LibC::Float, b : LibC::Float, a : LibC::Float) : Color
  fun premul_rgba = al_premul_rgba(r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Color
  fun premul_rgba_f = al_premul_rgba_f(r : LibC::Float, g : LibC::Float, b : LibC::Float, a : LibC::Float) : Color
  fun unmap_rgb = al_unmap_rgb(color : Color, r : UInt8*, g : UInt8*, b : UInt8*)
  fun unmap_rgba = al_unmap_rgba(color : Color, r : UInt8*, g : UInt8*, b : UInt8*, a : UInt8*)
  fun unmap_rgb_f = al_unmap_rgb_f(color : Color, r : LibC::Float*, g : LibC::Float*, b : LibC::Float*)
  fun unmap_rgba_f = al_unmap_rgba_f(color : Color, r : LibC::Float*, g : LibC::Float*, b : LibC::Float*, a : LibC::Float*)
  fun get_pixel_size = al_get_pixel_size(format : LibC::Int) : LibC::Int
  fun get_pixel_format_bits = al_get_pixel_format_bits(format : LibC::Int) : LibC::Int
  fun get_pixel_block_size = al_get_pixel_block_size(format : LibC::Int) : LibC::Int
  fun get_pixel_block_width = al_get_pixel_block_width(format : LibC::Int) : LibC::Int
  fun get_pixel_block_height = al_get_pixel_block_height(format : LibC::Int) : LibC::Int
  MemoryBitmap           =    1
  X_KeepBitmapFormat     =    2
  ForceLocking           =    4
  NoPreserveTexture      =    8
  X_AlphaTest            =   16
  X_InternalOpengl       =   32
  MinLinear              =   64
  MagLinear              =  128
  Mipmap                 =  256
  X_NoPremultipliedAlpha =  512
  VideoBitmap            = 1024
  ConvertBitmap          = 4096
  fun set_new_bitmap_format = al_set_new_bitmap_format(format : LibC::Int)
  fun set_new_bitmap_flags = al_set_new_bitmap_flags(flags : LibC::Int)
  fun get_new_bitmap_format = al_get_new_bitmap_format : LibC::Int
  fun get_new_bitmap_flags = al_get_new_bitmap_flags : LibC::Int
  fun add_new_bitmap_flag = al_add_new_bitmap_flag(flag : LibC::Int)
  fun get_bitmap_width = al_get_bitmap_width(bitmap : Bitmap) : LibC::Int
  type Bitmap = Void*
  fun get_bitmap_height = al_get_bitmap_height(bitmap : Bitmap) : LibC::Int
  fun get_bitmap_format = al_get_bitmap_format(bitmap : Bitmap) : LibC::Int
  fun get_bitmap_flags = al_get_bitmap_flags(bitmap : Bitmap) : LibC::Int
  fun create_bitmap = al_create_bitmap(w : LibC::Int, h : LibC::Int) : Bitmap
  fun destroy_bitmap = al_destroy_bitmap(bitmap : Bitmap)
  fun put_pixel = al_put_pixel(x : LibC::Int, y : LibC::Int, color : Color)
  fun put_blended_pixel = al_put_blended_pixel(x : LibC::Int, y : LibC::Int, color : Color)
  fun get_pixel = al_get_pixel(bitmap : Bitmap, x : LibC::Int, y : LibC::Int) : Color
  fun convert_mask_to_alpha = al_convert_mask_to_alpha(bitmap : Bitmap, mask_color : Color)
  fun set_clipping_rectangle = al_set_clipping_rectangle(x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int)
  fun reset_clipping_rectangle = al_reset_clipping_rectangle
  fun get_clipping_rectangle = al_get_clipping_rectangle(x : LibC::Int*, y : LibC::Int*, w : LibC::Int*, h : LibC::Int*)
  fun create_sub_bitmap = al_create_sub_bitmap(parent : Bitmap, x : LibC::Int, y : LibC::Int, w : LibC::Int, h : LibC::Int) : Bitmap
  fun is_sub_bitmap = al_is_sub_bitmap(bitmap : Bitmap) : LibC::Bool
  fun get_parent_bitmap = al_get_parent_bitmap(bitmap : Bitmap) : Bitmap
  fun get_bitmap_x = al_get_bitmap_x(bitmap : Bitmap) : LibC::Int
  fun get_bitmap_y = al_get_bitmap_y(bitmap : Bitmap) : LibC::Int
  fun reparent_bitmap = al_reparent_bitmap(bitmap : Bitmap, parent : Bitmap, x : LibC::Int, y : LibC::Int, w : LibC::Int, h : LibC::Int)
  fun clone_bitmap = al_clone_bitmap(bitmap : Bitmap) : Bitmap
  fun convert_bitmap = al_convert_bitmap(bitmap : Bitmap)
  fun convert_memory_bitmaps = al_convert_memory_bitmaps
  FlipHorizontal = 1
  FlipVertical = 2
  fun draw_bitmap = al_draw_bitmap(bitmap : Bitmap, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_bitmap_region = al_draw_bitmap_region(bitmap : Bitmap, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_scaled_bitmap = al_draw_scaled_bitmap(bitmap : Bitmap, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, dw : LibC::Float, dh : LibC::Float, flags : LibC::Int)
  fun draw_rotated_bitmap = al_draw_rotated_bitmap(bitmap : Bitmap, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_scaled_rotated_bitmap = al_draw_scaled_rotated_bitmap(bitmap : Bitmap, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, xscale : LibC::Float, yscale : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_tinted_bitmap = al_draw_tinted_bitmap(bitmap : Bitmap, tint : Color, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_tinted_bitmap_region = al_draw_tinted_bitmap_region(bitmap : Bitmap, tint : Color, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_tinted_scaled_bitmap = al_draw_tinted_scaled_bitmap(bitmap : Bitmap, tint : Color, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, dw : LibC::Float, dh : LibC::Float, flags : LibC::Int)
  fun draw_tinted_rotated_bitmap = al_draw_tinted_rotated_bitmap(bitmap : Bitmap, tint : Color, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_tinted_scaled_rotated_bitmap = al_draw_tinted_scaled_rotated_bitmap(bitmap : Bitmap, tint : Color, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, xscale : LibC::Float, yscale : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_tinted_scaled_rotated_bitmap_region = al_draw_tinted_scaled_rotated_bitmap_region(bitmap : Bitmap, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, tint : Color, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, xscale : LibC::Float, yscale : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun create_path = al_create_path(str : LibC::Char*) : Path
  type Path = Void*
  fun create_path_for_directory = al_create_path_for_directory(str : LibC::Char*) : Path
  fun clone_path = al_clone_path(path : Path) : Path
  fun get_path_num_components = al_get_path_num_components(path : Path) : LibC::Int
  fun get_path_component = al_get_path_component(path : Path, i : LibC::Int) : LibC::Char*
  fun replace_path_component = al_replace_path_component(path : Path, i : LibC::Int, s : LibC::Char*)
  fun remove_path_component = al_remove_path_component(path : Path, i : LibC::Int)
  fun insert_path_component = al_insert_path_component(path : Path, i : LibC::Int, s : LibC::Char*)
  fun get_path_tail = al_get_path_tail(path : Path) : LibC::Char*
  fun drop_path_tail = al_drop_path_tail(path : Path)
  fun append_path_component = al_append_path_component(path : Path, s : LibC::Char*)
  fun join_paths = al_join_paths(path : Path, tail : Path) : LibC::Bool
  fun rebase_path = al_rebase_path(head : Path, tail : Path) : LibC::Bool
  fun path_cstr = al_path_cstr(path : Path, delim : LibC::Char) : LibC::Char*
  fun destroy_path = al_destroy_path(path : Path)
  fun set_path_drive = al_set_path_drive(path : Path, drive : LibC::Char*)
  fun get_path_drive = al_get_path_drive(path : Path) : LibC::Char*
  fun set_path_filename = al_set_path_filename(path : Path, filename : LibC::Char*)
  fun get_path_filename = al_get_path_filename(path : Path) : LibC::Char*
  fun get_path_extension = al_get_path_extension(path : Path) : LibC::Char*
  fun set_path_extension = al_set_path_extension(path : Path, extension : LibC::Char*) : LibC::Bool
  fun get_path_basename = al_get_path_basename(path : Path) : LibC::Char*
  fun make_path_canonical = al_make_path_canonical(path : Path) : LibC::Bool
  fun ustr_new = al_ustr_new(s : LibC::Char*) : Ustr*

  struct X_AlTagbstring
    mlen : LibC::Int
    slen : LibC::Int
    data : UInt8*
  end

  type Ustr = X_AlTagbstring
  fun ustr_new_from_buffer = al_ustr_new_from_buffer(s : LibC::Char*, size : LibC::SizeT) : Ustr*
  fun ustr_newf = al_ustr_newf(fmt : LibC::Char*, ...) : Ustr*
  fun ustr_free = al_ustr_free(us : Ustr*)
  fun cstr = al_cstr(us : Ustr*) : LibC::Char*
  fun ustr_to_buffer = al_ustr_to_buffer(us : Ustr*, buffer : LibC::Char*, size : LibC::Int)
  fun cstr_dup = al_cstr_dup(us : Ustr*) : LibC::Char*
  fun ustr_dup = al_ustr_dup(us : Ustr*) : Ustr*
  fun ustr_dup_substr = al_ustr_dup_substr(us : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : Ustr*
  fun ustr_empty_string = al_ustr_empty_string : Ustr*
  fun ref_cstr = al_ref_cstr(info : UstrInfo*, s : LibC::Char*) : Ustr*
  type UstrInfo = X_AlTagbstring
  fun ref_buffer = al_ref_buffer(info : UstrInfo*, s : LibC::Char*, size : LibC::SizeT) : Ustr*
  fun ref_ustr = al_ref_ustr(info : UstrInfo*, us : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : Ustr*
  fun ustr_size = al_ustr_size(us : Ustr*) : LibC::SizeT
  fun ustr_length = al_ustr_length(us : Ustr*) : LibC::SizeT
  fun ustr_offset = al_ustr_offset(us : Ustr*, index : LibC::Int) : LibC::Int
  fun ustr_next = al_ustr_next(us : Ustr*, pos : LibC::Int*) : LibC::Bool
  fun ustr_prev = al_ustr_prev(us : Ustr*, pos : LibC::Int*) : LibC::Bool
  fun ustr_get = al_ustr_get(us : Ustr*, pos : LibC::Int) : Int32T
  alias Int32T = LibC::Int
  fun ustr_get_next = al_ustr_get_next(us : Ustr*, pos : LibC::Int*) : Int32T
  fun ustr_prev_get = al_ustr_prev_get(us : Ustr*, pos : LibC::Int*) : Int32T
  fun ustr_insert = al_ustr_insert(us1 : Ustr*, pos : LibC::Int, us2 : Ustr*) : LibC::Bool
  fun ustr_insert_cstr = al_ustr_insert_cstr(us : Ustr*, pos : LibC::Int, us2 : LibC::Char*) : LibC::Bool
  fun ustr_insert_chr = al_ustr_insert_chr(us : Ustr*, pos : LibC::Int, c : Int32T) : LibC::SizeT
  fun ustr_append = al_ustr_append(us1 : Ustr*, us2 : Ustr*) : LibC::Bool
  fun ustr_append_cstr = al_ustr_append_cstr(us : Ustr*, s : LibC::Char*) : LibC::Bool
  fun ustr_append_chr = al_ustr_append_chr(us : Ustr*, c : Int32T) : LibC::SizeT
  fun ustr_appendf = al_ustr_appendf(us : Ustr*, fmt : LibC::Char*, ...) : LibC::Bool
  fun ustr_vappendf = al_ustr_vappendf(us : Ustr*, fmt : LibC::Char*, ap : VaList) : LibC::Bool
  alias VaList = LibC::VaList
  fun ustr_remove_chr = al_ustr_remove_chr(us : Ustr*, pos : LibC::Int) : LibC::Bool
  fun ustr_remove_range = al_ustr_remove_range(us : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : LibC::Bool
  fun ustr_truncate = al_ustr_truncate(us : Ustr*, start_pos : LibC::Int) : LibC::Bool
  fun ustr_ltrim_ws = al_ustr_ltrim_ws(us : Ustr*) : LibC::Bool
  fun ustr_rtrim_ws = al_ustr_rtrim_ws(us : Ustr*) : LibC::Bool
  fun ustr_trim_ws = al_ustr_trim_ws(us : Ustr*) : LibC::Bool
  fun ustr_assign = al_ustr_assign(us1 : Ustr*, us2 : Ustr*) : LibC::Bool
  fun ustr_assign_substr = al_ustr_assign_substr(us1 : Ustr*, us2 : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : LibC::Bool
  fun ustr_assign_cstr = al_ustr_assign_cstr(us1 : Ustr*, s : LibC::Char*) : LibC::Bool
  fun ustr_set_chr = al_ustr_set_chr(us : Ustr*, pos : LibC::Int, c : Int32T) : LibC::SizeT
  fun ustr_replace_range = al_ustr_replace_range(us1 : Ustr*, start_pos1 : LibC::Int, end_pos1 : LibC::Int, us2 : Ustr*) : LibC::Bool
  fun ustr_find_chr = al_ustr_find_chr(us : Ustr*, start_pos : LibC::Int, c : Int32T) : LibC::Int
  fun ustr_rfind_chr = al_ustr_rfind_chr(us : Ustr*, start_pos : LibC::Int, c : Int32T) : LibC::Int
  fun ustr_find_set = al_ustr_find_set(us : Ustr*, start_pos : LibC::Int, accept : Ustr*) : LibC::Int
  fun ustr_find_set_cstr = al_ustr_find_set_cstr(us : Ustr*, start_pos : LibC::Int, accept : LibC::Char*) : LibC::Int
  fun ustr_find_cset = al_ustr_find_cset(us : Ustr*, start_pos : LibC::Int, reject : Ustr*) : LibC::Int
  fun ustr_find_cset_cstr = al_ustr_find_cset_cstr(us : Ustr*, start_pos : LibC::Int, reject : LibC::Char*) : LibC::Int
  fun ustr_find_str = al_ustr_find_str(haystack : Ustr*, start_pos : LibC::Int, needle : Ustr*) : LibC::Int
  fun ustr_find_cstr = al_ustr_find_cstr(haystack : Ustr*, start_pos : LibC::Int, needle : LibC::Char*) : LibC::Int
  fun ustr_rfind_str = al_ustr_rfind_str(haystack : Ustr*, start_pos : LibC::Int, needle : Ustr*) : LibC::Int
  fun ustr_rfind_cstr = al_ustr_rfind_cstr(haystack : Ustr*, start_pos : LibC::Int, needle : LibC::Char*) : LibC::Int
  fun ustr_find_replace = al_ustr_find_replace(us : Ustr*, start_pos : LibC::Int, find : Ustr*, replace : Ustr*) : LibC::Bool
  fun ustr_find_replace_cstr = al_ustr_find_replace_cstr(us : Ustr*, start_pos : LibC::Int, find : LibC::Char*, replace : LibC::Char*) : LibC::Bool
  fun ustr_equal = al_ustr_equal(us1 : Ustr*, us2 : Ustr*) : LibC::Bool
  fun ustr_compare = al_ustr_compare(u : Ustr*, v : Ustr*) : LibC::Int
  fun ustr_ncompare = al_ustr_ncompare(us1 : Ustr*, us2 : Ustr*, n : LibC::Int) : LibC::Int
  fun ustr_has_prefix = al_ustr_has_prefix(u : Ustr*, v : Ustr*) : LibC::Bool
  fun ustr_has_prefix_cstr = al_ustr_has_prefix_cstr(u : Ustr*, s : LibC::Char*) : LibC::Bool
  fun ustr_has_suffix = al_ustr_has_suffix(u : Ustr*, v : Ustr*) : LibC::Bool
  fun ustr_has_suffix_cstr = al_ustr_has_suffix_cstr(us1 : Ustr*, s : LibC::Char*) : LibC::Bool
  fun utf8_width = al_utf8_width(c : Int32T) : LibC::SizeT
  fun utf8_encode = al_utf8_encode(s : LibC::Char*, c : Int32T) : LibC::SizeT
  fun ustr_new_from_utf16 = al_ustr_new_from_utf16(s : Uint16T*) : Ustr*
  alias Uint16T = LibC::UShort
  fun ustr_size_utf16 = al_ustr_size_utf16(us : Ustr*) : LibC::SizeT
  fun ustr_encode_utf16 = al_ustr_encode_utf16(us : Ustr*, s : Uint16T*, n : LibC::SizeT) : LibC::SizeT
  fun utf16_width = al_utf16_width(c : LibC::Int) : LibC::SizeT
  fun utf16_encode = al_utf16_encode(s : Uint16T*, c : Int32T) : LibC::SizeT

  struct FileInterface
    fi_fopen : (LibC::Char*, LibC::Char* -> Void*)
    fi_fclose : (File -> LibC::Bool)
    fi_fread : (File, Void*, LibC::SizeT -> LibC::SizeT)
    fi_fwrite : (File, Void*, LibC::SizeT -> LibC::SizeT)
    fi_fflush : (File -> LibC::Bool)
    fi_ftell : (File -> Int64T)
    fi_fseek : (File, Int64T, LibC::Int -> LibC::Bool)
    fi_feof : (File -> LibC::Bool)
    fi_ferror : (File -> LibC::Int)
    fi_ferrmsg : (File -> LibC::Char*)
    fi_fclearerr : (File -> Void)
    fi_fungetc : (File, LibC::Int -> LibC::Int)
    fi_fsize : (File -> OffT)
  end

  type File = Void*
  alias Int64T = LibC::LongLong
  alias X__Int64T = LibC::LongLong
  alias X__DarwinOffT = X__Int64T
  alias OffT = X__DarwinOffT
  fun fopen = al_fopen(path : LibC::Char*, mode : LibC::Char*) : File
  fun fopen_interface = al_fopen_interface(vt : FileInterface*, path : LibC::Char*, mode : LibC::Char*) : File
  fun create_file_handle = al_create_file_handle(vt : FileInterface*, userdata : Void*) : File
  fun fclose = al_fclose(f : File) : LibC::Bool
  fun fread = al_fread(f : File, ptr : Void*, size : LibC::SizeT) : LibC::SizeT
  fun fwrite = al_fwrite(f : File, ptr : Void*, size : LibC::SizeT) : LibC::SizeT
  fun fflush = al_fflush(f : File) : LibC::Bool
  fun ftell = al_ftell(f : File) : Int64T
  fun fseek = al_fseek(f : File, offset : Int64T, whence : LibC::Int) : LibC::Bool
  fun feof = al_feof(f : File) : LibC::Bool
  fun ferror = al_ferror(f : File) : LibC::Int
  fun ferrmsg = al_ferrmsg(f : File) : LibC::Char*
  fun fclearerr = al_fclearerr(f : File)
  fun fungetc = al_fungetc(f : File, c : LibC::Int) : LibC::Int
  fun fsize = al_fsize(f : File) : Int64T
  fun fgetc = al_fgetc(f : File) : LibC::Int
  fun fputc = al_fputc(f : File, c : LibC::Int) : LibC::Int
  fun fread16le = al_fread16le(f : File) : Int16T
  alias Int16T = LibC::Short
  fun fread16be = al_fread16be(f : File) : Int16T
  fun fwrite16le = al_fwrite16le(f : File, w : Int16T) : LibC::SizeT
  fun fwrite16be = al_fwrite16be(f : File, w : Int16T) : LibC::SizeT
  fun fread32le = al_fread32le(f : File) : Int32T
  fun fread32be = al_fread32be(f : File) : Int32T
  fun fwrite32le = al_fwrite32le(f : File, l : Int32T) : LibC::SizeT
  fun fwrite32be = al_fwrite32be(f : File, l : Int32T) : LibC::SizeT
  fun fgets = al_fgets(f : File, p : LibC::Char*, max : LibC::SizeT) : LibC::Char*
  fun fget_ustr = al_fget_ustr(f : File) : Ustr*
  fun fputs = al_fputs(f : File, p : LibC::Char*) : LibC::Int
  fun fprintf = al_fprintf(f : File, format : LibC::Char*, ...) : LibC::Int
  fun vfprintf = al_vfprintf(f : File, format : LibC::Char*, args : VaList) : LibC::Int
  fun fopen_fd = al_fopen_fd(fd : LibC::Int, mode : LibC::Char*) : File
  fun make_temp_file = al_make_temp_file(tmpl : LibC::Char*, ret_path : Path*) : File
  fun fopen_slice = al_fopen_slice(fp : File, initial_size : LibC::SizeT, mode : LibC::Char*) : File
  fun get_new_file_interface = al_get_new_file_interface : FileInterface*
  fun set_new_file_interface = al_set_new_file_interface(file_interface : FileInterface*)
  fun set_standard_file_interface = al_set_standard_file_interface
  fun get_file_userdata = al_get_file_userdata(f : File) : Void*
  KeepBitmapFormat     =    2
  NoPremultipliedAlpha =  512
  KeepIndex            = 2048
  fun register_bitmap_loader = al_register_bitmap_loader(ext : LibC::Char*, loader : IioLoaderFunction) : LibC::Bool
  alias IioLoaderFunction = (LibC::Char*, LibC::Int -> Bitmap)
  fun register_bitmap_saver = al_register_bitmap_saver(ext : LibC::Char*, saver : IioSaverFunction) : LibC::Bool
  alias IioSaverFunction = (LibC::Char*, Bitmap -> LibC::Bool)
  fun register_bitmap_loader_f = al_register_bitmap_loader_f(ext : LibC::Char*, fs_loader : IioFsLoaderFunction) : LibC::Bool
  alias IioFsLoaderFunction = (File, LibC::Int -> Bitmap)
  fun register_bitmap_saver_f = al_register_bitmap_saver_f(ext : LibC::Char*, fs_saver : IioFsSaverFunction) : LibC::Bool
  alias IioFsSaverFunction = (File, Bitmap -> LibC::Bool)
  fun register_bitmap_identifier = al_register_bitmap_identifier(ext : LibC::Char*, identifier : IioIdentifierFunction) : LibC::Bool
  alias IioIdentifierFunction = (File -> LibC::Bool)
  fun load_bitmap = al_load_bitmap(filename : LibC::Char*) : Bitmap
  fun load_bitmap_flags = al_load_bitmap_flags(filename : LibC::Char*, flags : LibC::Int) : Bitmap
  fun load_bitmap_f = al_load_bitmap_f(fp : File, ident : LibC::Char*) : Bitmap
  fun load_bitmap_flags_f = al_load_bitmap_flags_f(fp : File, ident : LibC::Char*, flags : LibC::Int) : Bitmap
  fun save_bitmap = al_save_bitmap(filename : LibC::Char*, bitmap : Bitmap) : LibC::Bool
  fun save_bitmap_f = al_save_bitmap_f(fp : File, ident : LibC::Char*, bitmap : Bitmap) : LibC::Bool
  fun identify_bitmap_f = al_identify_bitmap_f(fp : File) : LibC::Char*
  fun identify_bitmap = al_identify_bitmap(filename : LibC::Char*) : LibC::Char*
  LockReadwrite = 0
  LockReadonly = 1
  LockWriteonly = 2

  struct LockedRegion
    data : Void*
    format : LibC::Int
    pitch : LibC::Int
    pixel_size : LibC::Int
  end

  fun lock_bitmap = al_lock_bitmap(bitmap : Bitmap, format : LibC::Int, flags : LibC::Int) : LockedRegion*
  fun lock_bitmap_region = al_lock_bitmap_region(bitmap : Bitmap, x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int, format : LibC::Int, flags : LibC::Int) : LockedRegion*
  fun lock_bitmap_blocked = al_lock_bitmap_blocked(bitmap : Bitmap, flags : LibC::Int) : LockedRegion*
  fun lock_bitmap_region_blocked = al_lock_bitmap_region_blocked(bitmap : Bitmap, x_block : LibC::Int, y_block : LibC::Int, width_block : LibC::Int, height_block : LibC::Int, flags : LibC::Int) : LockedRegion*
  fun unlock_bitmap = al_unlock_bitmap(bitmap : Bitmap)
  fun is_bitmap_locked = al_is_bitmap_locked(bitmap : Bitmap) : LibC::Bool
  fun set_blender = al_set_blender(op : LibC::Int, source : LibC::Int, dest : LibC::Int)
  fun set_blend_color = al_set_blend_color(color : Color)
  fun get_blender = al_get_blender(op : LibC::Int*, source : LibC::Int*, dest : LibC::Int*)
  fun get_blend_color = al_get_blend_color : Color
  fun set_separate_blender = al_set_separate_blender(op : LibC::Int, source : LibC::Int, dest : LibC::Int, alpha_op : LibC::Int, alpha_source : LibC::Int, alpha_dest : LibC::Int)
  fun get_separate_blender = al_get_separate_blender(op : LibC::Int*, source : LibC::Int*, dest : LibC::Int*, alpha_op : LibC::Int*, alpha_src : LibC::Int*, alpha_dest : LibC::Int*)
  EventJoystickAxis          =  1
  EventJoystickButtonDown    =  2
  EventJoystickButtonUp      =  3
  EventJoystickConfiguration =  4
  EventKeyDown               = 10
  EventKeyChar               = 11
  EventKeyUp                 = 12
  EventMouseAxes             = 20
  EventMouseButtonDown       = 21
  EventMouseButtonUp         = 22
  EventMouseEnterDisplay     = 23
  EventMouseLeaveDisplay     = 24
  EventMouseWarped           = 25
  EventTimer                 = 30
  EventDisplayExpose         = 40
  EventDisplayResize         = 41
  EventDisplayClose          = 42
  EventDisplayLost           = 43
  EventDisplayFound          = 44
  EventDisplaySwitchIn       = 45
  EventDisplaySwitchOut      = 46
  EventDisplayOrientation    = 47
  EventDisplayHaltDrawing    = 48
  EventDisplayResumeDrawing  = 49
  EventTouchBegin            = 50
  EventTouchEnd              = 51
  EventTouchMove             = 52
  EventTouchCancel           = 53
  EventDisplayConnected      = 60
  EventDisplayDisconnected   = 61

  struct EventSource
    __pad : LibC::Int[32]
  end

  struct AnyEvent
    type : EventType
    source : EventSource*
    timestamp : LibC::Double
  end

  alias EventType = LibC::UInt

  struct DisplayEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    x : LibC::Int
    y : LibC::Int
    width : LibC::Int
    height : LibC::Int
    orientation : LibC::Int
  end

  struct JoystickEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    id : Void*
    stick : LibC::Int
    axis : LibC::Int
    pos : LibC::Float
    button : LibC::Int
  end

  struct KeyboardEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    display : Void*
    keycode : LibC::Int
    unichar : LibC::Int
    modifiers : LibC::UInt
    repeat : LibC::Bool
  end

  struct MouseEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    display : Void*
    x : LibC::Int
    y : LibC::Int
    z : LibC::Int
    w : LibC::Int
    dx : LibC::Int
    dy : LibC::Int
    dz : LibC::Int
    dw : LibC::Int
    button : LibC::UInt
    pressure : LibC::Float
  end

  struct TimerEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    count : Int64T
    error : LibC::Double
  end

  struct TouchEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    display : Void*
    id : LibC::Int
    x : LibC::Float
    y : LibC::Float
    dx : LibC::Float
    dy : LibC::Float
    primary : LibC::Bool
  end

  struct UserEvent
    type : EventType
    source : EventSource*
    timestamp : LibC::Double
    __internal__descr : Void*
    data1 : IntptrT
    data2 : IntptrT
    data3 : IntptrT
    data4 : IntptrT
  end

  alias X__DarwinIntptrT = LibC::Long
  alias IntptrT = X__DarwinIntptrT

  union Event
    type : EventType
    any : AnyEvent
    display : DisplayEvent
    joystick : JoystickEvent
    keyboard : KeyboardEvent
    mouse : MouseEvent
    timer : TimerEvent
    touch : TouchEvent
    user : UserEvent
  end

  fun init_user_event_source = al_init_user_event_source(x0 : EventSource*)
  fun destroy_user_event_source = al_destroy_user_event_source(x0 : EventSource*)
  fun emit_user_event = al_emit_user_event(x0 : EventSource*, x1 : Event*, dtor : (UserEvent* -> Void)) : LibC::Bool
  fun unref_user_event = al_unref_user_event(x0 : UserEvent*)
  fun set_event_source_data = al_set_event_source_data(x0 : EventSource*, data : IntptrT)
  fun get_event_source_data = al_get_event_source_data(x0 : EventSource*) : IntptrT
  fun create_event_queue = al_create_event_queue : EventQueue
  type EventQueue = Void*
  fun destroy_event_queue = al_destroy_event_queue(x0 : EventQueue)
  fun is_event_source_registered = al_is_event_source_registered(x0 : EventQueue, x1 : EventSource*) : LibC::Bool
  fun register_event_source = al_register_event_source(x0 : EventQueue, x1 : EventSource*)
  fun unregister_event_source = al_unregister_event_source(x0 : EventQueue, x1 : EventSource*)
  fun pause_event_queue = al_pause_event_queue(x0 : EventQueue, x1 : LibC::Bool)
  fun is_event_queue_paused = al_is_event_queue_paused(x0 : EventQueue) : LibC::Bool
  fun is_event_queue_empty = al_is_event_queue_empty(x0 : EventQueue) : LibC::Bool
  fun get_next_event = al_get_next_event(x0 : EventQueue, ret_event : Event*) : LibC::Bool
  fun peek_next_event = al_peek_next_event(x0 : EventQueue, ret_event : Event*) : LibC::Bool
  fun drop_next_event = al_drop_next_event(x0 : EventQueue) : LibC::Bool
  fun flush_event_queue = al_flush_event_queue(x0 : EventQueue)
  fun wait_for_event = al_wait_for_event(x0 : EventQueue, ret_event : Event*)
  fun wait_for_event_timed = al_wait_for_event_timed(x0 : EventQueue, ret_event : Event*, secs : LibC::Float) : LibC::Bool
  fun wait_for_event_until = al_wait_for_event_until(queue : EventQueue, ret_event : Event*, timeout : Timeout*) : LibC::Bool
  Windowed                =     1
  Fullscreen              =     2
  Opengl                  =     4
  Direct3DInternal        =     8
  Resizable               =    16
  Frameless               =    32
  Noframe                 =    32
  GenerateExposeEvents    =    64
  Opengl30                =   128
  OpenglForwardCompatible =   256
  FullscreenWindow        =   512
  Minimized               =  1024
  ProgrammablePipeline    =  2048
  GtkToplevelInternal     =  4096
  Maximized               =  8192
  OpenglEsProfile         = 16384
  Dontcare                =     0
  Require                 =     1
  Suggest                 =     2
  X_PrimMaxUserAttr       =    10
  fun set_new_display_refresh_rate = al_set_new_display_refresh_rate(refresh_rate : LibC::Int)
  fun set_new_display_flags = al_set_new_display_flags(flags : LibC::Int)
  fun get_new_display_refresh_rate = al_get_new_display_refresh_rate : LibC::Int
  fun get_new_display_flags = al_get_new_display_flags : LibC::Int
  fun set_new_window_title = al_set_new_window_title(title : LibC::Char*)
  fun get_new_window_title = al_get_new_window_title : LibC::Char*
  fun get_display_width = al_get_display_width(display : Display*) : LibC::Int
  fun get_display_height = al_get_display_height(display : Display*) : LibC::Int
  fun get_display_format = al_get_display_format(display : Display*) : LibC::Int
  fun get_display_refresh_rate = al_get_display_refresh_rate(display : Display*) : LibC::Int
  fun get_display_flags = al_get_display_flags(display : Display*) : LibC::Int
  fun get_display_orientation = al_get_display_orientation(display : Display*) : LibC::Int
  fun set_display_flag = al_set_display_flag(display : Display*, flag : LibC::Int, onoff : LibC::Bool) : LibC::Bool
  fun create_display = al_create_display(w : LibC::Int, h : LibC::Int) : Display*
  fun destroy_display = al_destroy_display(display : Display*)
  fun get_current_display = al_get_current_display : Display*
  fun set_target_bitmap = al_set_target_bitmap(bitmap : Bitmap)
  fun set_target_backbuffer = al_set_target_backbuffer(display : Display*)
  fun get_backbuffer = al_get_backbuffer(display : Display*) : Bitmap
  fun get_target_bitmap = al_get_target_bitmap : Bitmap
  fun acknowledge_resize = al_acknowledge_resize(display : Display*) : LibC::Bool
  fun resize_display = al_resize_display(display : Display*, width : LibC::Int, height : LibC::Int) : LibC::Bool
  fun flip_display = al_flip_display
  fun update_display_region = al_update_display_region(x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int)
  fun is_compatible_bitmap = al_is_compatible_bitmap(bitmap : Bitmap) : LibC::Bool
  fun wait_for_vsync = al_wait_for_vsync : LibC::Bool
  fun get_display_event_source = al_get_display_event_source(display : Display*) : EventSource*
  fun set_display_icon = al_set_display_icon(display : Display*, icon : Bitmap)
  fun set_display_icons = al_set_display_icons(display : Display*, num_icons : LibC::Int, icons : Bitmap*)
  fun get_new_display_adapter = al_get_new_display_adapter : LibC::Int
  fun set_new_display_adapter = al_set_new_display_adapter(adapter : LibC::Int)
  fun set_new_window_position = al_set_new_window_position(x : LibC::Int, y : LibC::Int)
  fun get_new_window_position = al_get_new_window_position(x : LibC::Int*, y : LibC::Int*)
  fun set_window_position = al_set_window_position(display : Display*, x : LibC::Int, y : LibC::Int)
  fun get_window_position = al_get_window_position(display : Display*, x : LibC::Int*, y : LibC::Int*)
  fun set_window_constraints = al_set_window_constraints(display : Display*, min_w : LibC::Int, min_h : LibC::Int, max_w : LibC::Int, max_h : LibC::Int) : LibC::Bool
  fun get_window_constraints = al_get_window_constraints(display : Display*, min_w : LibC::Int*, min_h : LibC::Int*, max_w : LibC::Int*, max_h : LibC::Int*) : LibC::Bool
  fun set_window_title = al_set_window_title(display : Display*, title : LibC::Char*)
  fun set_new_display_option = al_set_new_display_option(option : LibC::Int, value : LibC::Int, importance : LibC::Int)
  fun get_new_display_option = al_get_new_display_option(option : LibC::Int, importance : LibC::Int*) : LibC::Int
  fun reset_new_display_options = al_reset_new_display_options
  fun set_display_option = al_set_display_option(display : Display*, option : LibC::Int, value : LibC::Int)
  fun get_display_option = al_get_display_option(display : Display*, option : LibC::Int) : LibC::Int
  fun hold_bitmap_drawing = al_hold_bitmap_drawing(hold : LibC::Bool)
  fun is_bitmap_drawing_held = al_is_bitmap_drawing_held : LibC::Bool
  fun acknowledge_drawing_halt = al_acknowledge_drawing_halt(display : Display*)
  fun acknowledge_drawing_resume = al_acknowledge_drawing_resume(display : Display*)
  fun get_clipboard_text = al_get_clipboard_text(display : Display*) : LibC::Char*
  fun set_clipboard_text = al_set_clipboard_text(display : Display*, text : LibC::Char*) : LibC::Bool
  fun clipboard_has_text = al_clipboard_has_text(display : Display*) : LibC::Bool
  fun create_config = al_create_config : Config
  type Config = Void*
  fun add_config_section = al_add_config_section(config : Config, name : LibC::Char*)
  fun set_config_value = al_set_config_value(config : Config, section : LibC::Char*, key : LibC::Char*, value : LibC::Char*)
  fun add_config_comment = al_add_config_comment(config : Config, section : LibC::Char*, comment : LibC::Char*)
  fun get_config_value = al_get_config_value(config : Config, section : LibC::Char*, key : LibC::Char*) : LibC::Char*
  fun load_config_file = al_load_config_file(filename : LibC::Char*) : Config
  fun load_config_file_f = al_load_config_file_f(filename : File) : Config
  fun save_config_file = al_save_config_file(filename : LibC::Char*, config : Config) : LibC::Bool
  fun save_config_file_f = al_save_config_file_f(file : File, config : Config) : LibC::Bool
  fun merge_config_into = al_merge_config_into(master : Config, add : Config)
  fun merge_config = al_merge_config(cfg1 : Config, cfg2 : Config) : Config
  fun destroy_config = al_destroy_config(config : Config)
  fun remove_config_section = al_remove_config_section(config : Config, section : LibC::Char*) : LibC::Bool
  fun remove_config_key = al_remove_config_key(config : Config, section : LibC::Char*, key : LibC::Char*) : LibC::Bool
  fun get_first_config_section = al_get_first_config_section(config : Config, iterator : ConfigSection*) : LibC::Char*
  type ConfigSection = Void*
  fun get_next_config_section = al_get_next_config_section(iterator : ConfigSection*) : LibC::Char*
  fun get_first_config_entry = al_get_first_config_entry(config : Config, section : LibC::Char*, iterator : ConfigEntry*) : LibC::Char*
  type ConfigEntry = Void*
  fun get_next_config_entry = al_get_next_config_entry(iterator : ConfigEntry*) : LibC::Char*
  fun get_cpu_count = al_get_cpu_count : LibC::Int
  fun get_ram_size = al_get_ram_size : LibC::Int
  fun register_assert_handler = al_register_assert_handler(handler : (LibC::Char*, LibC::Char*, LibC::Int, LibC::Char* -> Void))
  fun register_trace_handler = al_register_trace_handler(handler : (LibC::Char* -> Void))
  fun clear_to_color = al_clear_to_color(color : Color)
  fun clear_depth_buffer = al_clear_depth_buffer(x : LibC::Float)
  fun draw_pixel = al_draw_pixel(x : LibC::Float, y : LibC::Float, color : Color)
  fun get_errno = al_get_errno : LibC::Int
  fun set_errno = al_set_errno(errnum : LibC::Int)
  alias Fixed = Int32T
  fun fixsqrt = al_fixsqrt(x : Fixed) : Fixed
  fun fixhypot = al_fixhypot(x : Fixed, y : Fixed) : Fixed
  fun fixatan = al_fixatan(x : Fixed) : Fixed
  fun fixatan2 = al_fixatan2(y : Fixed, x : Fixed) : Fixed
  fun ftofix = al_ftofix(x : LibC::Double) : Fixed
  fun ftofix = al_ftofix(x : LibC::Double) : Fixed
  fun fixtof = al_fixtof(x : Fixed) : LibC::Double
  fun fixtof = al_fixtof(x : Fixed) : LibC::Double
  fun fixadd = al_fixadd(x : Fixed, y : Fixed) : Fixed
  fun fixadd = al_fixadd(x : Fixed, y : Fixed) : Fixed
  fun fixsub = al_fixsub(x : Fixed, y : Fixed) : Fixed
  fun fixsub = al_fixsub(x : Fixed, y : Fixed) : Fixed
  fun fixmul = al_fixmul(x : Fixed, y : Fixed) : Fixed
  fun fixmul = al_fixmul(x : Fixed, y : Fixed) : Fixed
  fun fixdiv = al_fixdiv(x : Fixed, y : Fixed) : Fixed
  fun fixdiv = al_fixdiv(x : Fixed, y : Fixed) : Fixed
  fun fixfloor = al_fixfloor(x : Fixed) : LibC::Int
  fun fixfloor = al_fixfloor(x : Fixed) : LibC::Int
  fun fixceil = al_fixceil(x : Fixed) : LibC::Int
  fun fixceil = al_fixceil(x : Fixed) : LibC::Int
  fun itofix = al_itofix(x : LibC::Int) : Fixed
  fun itofix = al_itofix(x : LibC::Int) : Fixed
  fun fixtoi = al_fixtoi(x : Fixed) : LibC::Int
  fun fixtoi = al_fixtoi(x : Fixed) : LibC::Int
  fun fixcos = al_fixcos(x : Fixed) : Fixed
  fun fixcos = al_fixcos(x : Fixed) : Fixed
  fun fixsin = al_fixsin(x : Fixed) : Fixed
  fun fixsin = al_fixsin(x : Fixed) : Fixed
  fun fixtan = al_fixtan(x : Fixed) : Fixed
  fun fixtan = al_fixtan(x : Fixed) : Fixed
  fun fixacos = al_fixacos(x : Fixed) : Fixed
  fun fixacos = al_fixacos(x : Fixed) : Fixed
  fun fixasin = al_fixasin(x : Fixed) : Fixed
  fun fixasin = al_fixasin(x : Fixed) : Fixed

  struct FsEntry
    vtable : FsInterface*
  end

  struct FsInterface
    fs_create_entry : (LibC::Char* -> FsEntry*)
    fs_destroy_entry : (FsEntry* -> Void)
    fs_entry_name : (FsEntry* -> LibC::Char*)
    fs_update_entry : (FsEntry* -> LibC::Bool)
    fs_entry_mode : (FsEntry* -> Uint32T)
    fs_entry_atime : (FsEntry* -> TimeT)
    fs_entry_mtime : (FsEntry* -> TimeT)
    fs_entry_ctime : (FsEntry* -> TimeT)
    fs_entry_size : (FsEntry* -> OffT)
    fs_entry_exists : (FsEntry* -> LibC::Bool)
    fs_remove_entry : (FsEntry* -> LibC::Bool)
    fs_open_directory : (FsEntry* -> LibC::Bool)
    fs_read_directory : (FsEntry* -> FsEntry*)
    fs_close_directory : (FsEntry* -> LibC::Bool)
    fs_filename_exists : (LibC::Char* -> LibC::Bool)
    fs_remove_filename : (LibC::Char* -> LibC::Bool)
    fs_get_current_directory : (-> LibC::Char*)
    fs_change_directory : (LibC::Char* -> LibC::Bool)
    fs_make_directory : (LibC::Char* -> LibC::Bool)
    fs_open_file : (FsEntry*, LibC::Char* -> File)
  end

  alias X__DarwinTimeT = LibC::Long
  alias TimeT = X__DarwinTimeT
  fun create_fs_entry = al_create_fs_entry(path : LibC::Char*) : FsEntry*
  fun destroy_fs_entry = al_destroy_fs_entry(e : FsEntry*)
  fun get_fs_entry_name = al_get_fs_entry_name(e : FsEntry*) : LibC::Char*
  fun update_fs_entry = al_update_fs_entry(e : FsEntry*) : LibC::Bool
  fun get_fs_entry_mode = al_get_fs_entry_mode(e : FsEntry*) : Uint32T
  fun get_fs_entry_atime = al_get_fs_entry_atime(e : FsEntry*) : TimeT
  fun get_fs_entry_mtime = al_get_fs_entry_mtime(e : FsEntry*) : TimeT
  fun get_fs_entry_ctime = al_get_fs_entry_ctime(e : FsEntry*) : TimeT
  fun get_fs_entry_size = al_get_fs_entry_size(e : FsEntry*) : OffT
  fun fs_entry_exists = al_fs_entry_exists(e : FsEntry*) : LibC::Bool
  fun remove_fs_entry = al_remove_fs_entry(e : FsEntry*) : LibC::Bool
  fun open_directory = al_open_directory(e : FsEntry*) : LibC::Bool
  fun read_directory = al_read_directory(e : FsEntry*) : FsEntry*
  fun close_directory = al_close_directory(e : FsEntry*) : LibC::Bool
  fun filename_exists = al_filename_exists(path : LibC::Char*) : LibC::Bool
  fun remove_filename = al_remove_filename(path : LibC::Char*) : LibC::Bool
  fun get_current_directory = al_get_current_directory : LibC::Char*
  fun change_directory = al_change_directory(path : LibC::Char*) : LibC::Bool
  fun make_directory = al_make_directory(path : LibC::Char*) : LibC::Bool
  fun open_fs_entry = al_open_fs_entry(e : FsEntry*, mode : LibC::Char*) : File
  fun for_each_fs_entry = al_for_each_fs_entry(dir : FsEntry*, callback : (FsEntry*, Void* -> LibC::Int), extra : Void*) : LibC::Int
  fun get_fs_interface = al_get_fs_interface : FsInterface*
  fun set_fs_interface = al_set_fs_interface(vtable : FsInterface*)
  fun set_standard_fs_interface = al_set_standard_fs_interface

  struct DisplayMode
    width : LibC::Int
    height : LibC::Int
    format : LibC::Int
    refresh_rate : LibC::Int
  end

  fun get_num_display_modes = al_get_num_display_modes : LibC::Int
  fun get_display_mode = al_get_display_mode(index : LibC::Int, mode : DisplayMode*) : DisplayMode*

  struct JoystickState
    stick : JoystickStateStick[16]
    button : LibC::Int[32]
  end

  struct JoystickStateStick
    axis : LibC::Float[3]
  end

  fun install_joystick = al_install_joystick : LibC::Bool
  fun uninstall_joystick = al_uninstall_joystick
  fun is_joystick_installed = al_is_joystick_installed : LibC::Bool
  fun reconfigure_joysticks = al_reconfigure_joysticks : LibC::Bool
  fun get_num_joysticks = al_get_num_joysticks : LibC::Int
  fun get_joystick = al_get_joystick(joyn : LibC::Int) : Joystick*
  alias Joystick = Void
  fun release_joystick = al_release_joystick(x0 : Joystick*)
  fun get_joystick_active = al_get_joystick_active(x0 : Joystick*) : LibC::Bool
  fun get_joystick_name = al_get_joystick_name(x0 : Joystick*) : LibC::Char*
  fun get_joystick_num_sticks = al_get_joystick_num_sticks(x0 : Joystick*) : LibC::Int
  fun get_joystick_stick_flags = al_get_joystick_stick_flags(x0 : Joystick*, stick : LibC::Int) : LibC::Int
  fun get_joystick_stick_name = al_get_joystick_stick_name(x0 : Joystick*, stick : LibC::Int) : LibC::Char*
  fun get_joystick_num_axes = al_get_joystick_num_axes(x0 : Joystick*, stick : LibC::Int) : LibC::Int
  fun get_joystick_axis_name = al_get_joystick_axis_name(x0 : Joystick*, stick : LibC::Int, axis : LibC::Int) : LibC::Char*
  fun get_joystick_num_buttons = al_get_joystick_num_buttons(x0 : Joystick*) : LibC::Int
  fun get_joystick_button_name = al_get_joystick_button_name(x0 : Joystick*, buttonn : LibC::Int) : LibC::Char*
  fun get_joystick_state = al_get_joystick_state(x0 : Joystick*, ret_state : JoystickState*)
  fun get_joystick_event_source = al_get_joystick_event_source : EventSource*
  KeyA             =     1
  KeyB             =     2
  KeyC             =     3
  KeyD             =     4
  KeyE             =     5
  KeyF             =     6
  KeyG             =     7
  KeyH             =     8
  KeyI             =     9
  KeyJ             =    10
  KeyK             =    11
  KeyL             =    12
  KeyM             =    13
  KeyN             =    14
  KeyO             =    15
  KeyP             =    16
  KeyQ             =    17
  KeyR             =    18
  KeyS             =    19
  KeyT             =    20
  KeyU             =    21
  KeyV             =    22
  KeyW             =    23
  KeyX             =    24
  KeyY             =    25
  KeyZ             =    26
  Key0             =    27
  Key1             =    28
  Key2             =    29
  Key3             =    30
  Key4             =    31
  Key5             =    32
  Key6             =    33
  Key7             =    34
  Key8             =    35
  Key9             =    36
  KeyPad0          =    37
  KeyPad1          =    38
  KeyPad2          =    39
  KeyPad3          =    40
  KeyPad4          =    41
  KeyPad5          =    42
  KeyPad6          =    43
  KeyPad7          =    44
  KeyPad8          =    45
  KeyPad9          =    46
  KeyF1            =    47
  KeyF2            =    48
  KeyF3            =    49
  KeyF4            =    50
  KeyF5            =    51
  KeyF6            =    52
  KeyF7            =    53
  KeyF8            =    54
  KeyF9            =    55
  KeyF10           =    56
  KeyF11           =    57
  KeyF12           =    58
  KeyEscape        =    59
  KeyTilde         =    60
  KeyMinus         =    61
  KeyEquals        =    62
  KeyBackspace     =    63
  KeyTab           =    64
  KeyOpenbrace     =    65
  KeyClosebrace    =    66
  KeyEnter         =    67
  KeySemicolon     =    68
  KeyQuote         =    69
  KeyBackslash     =    70
  KeyBackslash2    =    71
  KeyComma         =    72
  KeyFullstop      =    73
  KeySlash         =    74
  KeySpace         =    75
  KeyInsert        =    76
  KeyDelete        =    77
  KeyHome          =    78
  KeyEnd           =    79
  KeyPgup          =    80
  KeyPgdn          =    81
  KeyLeft          =    82
  KeyRight         =    83
  KeyUp            =    84
  KeyDown          =    85
  KeyPadSlash      =    86
  KeyPadAsterisk   =    87
  KeyPadMinus      =    88
  KeyPadPlus       =    89
  KeyPadDelete     =    90
  KeyPadEnter      =    91
  KeyPrintscreen   =    92
  KeyPause         =    93
  KeyAbntC1        =    94
  KeyYen           =    95
  KeyKana          =    96
  KeyConvert       =    97
  KeyNoconvert     =    98
  KeyAt            =    99
  KeyCircumflex    =   100
  KeyColon2        =   101
  KeyKanji         =   102
  KeyPadEquals     =   103
  KeyBackquote     =   104
  KeySemicolon2    =   105
  KeyCommand       =   106
  KeyBack          =   107
  KeyVolumeUp      =   108
  KeyVolumeDown    =   109
  KeySearch        =   110
  KeyDpadCenter    =   111
  KeyButtonX       =   112
  KeyButtonY       =   113
  KeyDpadUp        =   114
  KeyDpadDown      =   115
  KeyDpadLeft      =   116
  KeyDpadRight     =   117
  KeySelect        =   118
  KeyStart         =   119
  KeyButtonL1      =   120
  KeyButtonR1      =   121
  KeyButtonL2      =   122
  KeyButtonR2      =   123
  KeyButtonA       =   124
  KeyButtonB       =   125
  KeyThumbl        =   126
  KeyThumbr        =   127
  KeyUnknown       =   128
  KeyModifiers     =   215
  KeyLshift        =   215
  KeyRshift        =   216
  KeyLctrl         =   217
  KeyRctrl         =   218
  KeyAlt           =   219
  KeyAltgr         =   220
  KeyLwin          =   221
  KeyRwin          =   222
  KeyMenu          =   223
  KeyScrolllock    =   224
  KeyNumlock       =   225
  KeyCapslock      =   226
  KeyMax           =   227
  KeymodShift      =     1
  KeymodCtrl       =     2
  KeymodAlt        =     4
  KeymodLwin       =     8
  KeymodRwin       =    16
  KeymodMenu       =    32
  KeymodAltgr      =    64
  KeymodCommand    =   128
  KeymodScrolllock =   256
  KeymodNumlock    =   512
  KeymodCapslock   =  1024
  KeymodInaltseq   =  2048
  KeymodAccent1    =  4096
  KeymodAccent2    =  8192
  KeymodAccent3    = 16384
  KeymodAccent4    = 32768

  struct KeyboardState
    display : Void*
    __key_down__internal__ : LibC::UInt[8]
  end

  fun is_keyboard_installed = al_is_keyboard_installed : LibC::Bool
  fun install_keyboard = al_install_keyboard : LibC::Bool
  fun uninstall_keyboard = al_uninstall_keyboard
  fun set_keyboard_leds = al_set_keyboard_leds(leds : LibC::Int) : LibC::Bool
  fun keycode_to_name = al_keycode_to_name(keycode : LibC::Int) : LibC::Char*
  fun get_keyboard_state = al_get_keyboard_state(ret_state : KeyboardState*)
  fun key_down = al_key_down(x0 : KeyboardState*, keycode : LibC::Int) : LibC::Bool
  fun get_keyboard_event_source = al_get_keyboard_event_source : EventSource*

  struct MouseState
    x : LibC::Int
    y : LibC::Int
    z : LibC::Int
    w : LibC::Int
    more_axes : LibC::Int[4]
    buttons : LibC::Int
    pressure : LibC::Float
    display : Void*
  end

  fun is_mouse_installed = al_is_mouse_installed : LibC::Bool
  fun install_mouse = al_install_mouse : LibC::Bool
  fun uninstall_mouse = al_uninstall_mouse
  fun get_mouse_num_buttons = al_get_mouse_num_buttons : LibC::UInt
  fun get_mouse_num_axes = al_get_mouse_num_axes : LibC::UInt
  fun set_mouse_xy = al_set_mouse_xy(display : Void*, x : LibC::Int, y : LibC::Int) : LibC::Bool
  fun set_mouse_z = al_set_mouse_z(z : LibC::Int) : LibC::Bool
  fun set_mouse_w = al_set_mouse_w(w : LibC::Int) : LibC::Bool
  fun set_mouse_axis = al_set_mouse_axis(axis : LibC::Int, value : LibC::Int) : LibC::Bool
  fun get_mouse_state = al_get_mouse_state(ret_state : MouseState*)
  fun mouse_button_down = al_mouse_button_down(state : MouseState*, button : LibC::Int) : LibC::Bool
  fun get_mouse_state_axis = al_get_mouse_state_axis(state : MouseState*, axis : LibC::Int) : LibC::Int
  fun get_mouse_cursor_position = al_get_mouse_cursor_position(ret_x : LibC::Int*, ret_y : LibC::Int*) : LibC::Bool
  fun grab_mouse = al_grab_mouse(display : Void*) : LibC::Bool
  fun ungrab_mouse = al_ungrab_mouse : LibC::Bool
  fun set_mouse_wheel_precision = al_set_mouse_wheel_precision(precision : LibC::Int)
  fun get_mouse_wheel_precision = al_get_mouse_wheel_precision : LibC::Int
  fun get_mouse_event_source = al_get_mouse_event_source : EventSource*

  struct TouchInputState
    touches : TouchState[16]
  end

  struct TouchState
    id : LibC::Int
    x : LibC::Float
    y : LibC::Float
    dx : LibC::Float
    dy : LibC::Float
    primary : LibC::Bool
    display : Void*
  end

  fun is_touch_input_installed = al_is_touch_input_installed : LibC::Bool
  fun install_touch_input = al_install_touch_input : LibC::Bool
  fun uninstall_touch_input = al_uninstall_touch_input
  fun get_touch_input_state = al_get_touch_input_state(ret_state : TouchInputState*)
  fun get_touch_input_event_source = al_get_touch_input_event_source : EventSource*

  struct MemoryInterface
    mi_malloc : (LibC::SizeT, LibC::Int, LibC::Char*, LibC::Char* -> Void*)
    mi_free : (Void*, LibC::Int, LibC::Char*, LibC::Char* -> Void)
    mi_realloc : (Void*, LibC::SizeT, LibC::Int, LibC::Char*, LibC::Char* -> Void*)
    mi_calloc : (LibC::SizeT, LibC::SizeT, LibC::Int, LibC::Char*, LibC::Char* -> Void*)
  end

  fun set_memory_interface = al_set_memory_interface(iface : MemoryInterface*)
  fun malloc_with_context = al_malloc_with_context(n : LibC::SizeT, line : LibC::Int, file : LibC::Char*, func : LibC::Char*) : Void*
  fun free_with_context = al_free_with_context(ptr : Void*, line : LibC::Int, file : LibC::Char*, func : LibC::Char*)
  fun realloc_with_context = al_realloc_with_context(ptr : Void*, n : LibC::SizeT, line : LibC::Int, file : LibC::Char*, func : LibC::Char*) : Void*
  fun calloc_with_context = al_calloc_with_context(count : LibC::SizeT, n : LibC::SizeT, line : LibC::Int, file : LibC::Char*, func : LibC::Char*) : Void*

  struct MonitorInfo
    x1 : LibC::Int
    y1 : LibC::Int
    x2 : LibC::Int
    y2 : LibC::Int
  end

  DefaultDisplayAdapter = -1
  fun get_num_video_adapters = al_get_num_video_adapters : LibC::Int
  fun get_monitor_info = al_get_monitor_info(adapter : LibC::Int, info : MonitorInfo*) : LibC::Bool
  fun create_mouse_cursor = al_create_mouse_cursor(sprite : Bitmap*, xfocus : LibC::Int, yfocus : LibC::Int) : MouseCursor
  type MouseCursor = Void*
  fun destroy_mouse_cursor = al_destroy_mouse_cursor(x0 : MouseCursor)
  fun set_mouse_cursor = al_set_mouse_cursor(display : Display*, cursor : MouseCursor) : LibC::Bool
  fun set_system_mouse_cursor = al_set_system_mouse_cursor(display : Display*, cursor_id : SystemMouseCursor) : LibC::Bool
  enum SystemMouseCursor
    SystemMouseCursorNone        =  0
    SystemMouseCursorDefault     =  1
    SystemMouseCursorArrow       =  2
    SystemMouseCursorBusy        =  3
    SystemMouseCursorQuestion    =  4
    SystemMouseCursorEdit        =  5
    SystemMouseCursorMove        =  6
    SystemMouseCursorResizeN     =  7
    SystemMouseCursorResizeW     =  8
    SystemMouseCursorResizeS     =  9
    SystemMouseCursorResizeE     = 10
    SystemMouseCursorResizeNw    = 11
    SystemMouseCursorResizeSw    = 12
    SystemMouseCursorResizeSe    = 13
    SystemMouseCursorResizeNe    = 14
    SystemMouseCursorProgress    = 15
    SystemMouseCursorPrecision   = 16
    SystemMouseCursorLink        = 17
    SystemMouseCursorAltSelect   = 18
    SystemMouseCursorUnavailable = 19
    NumSystemMouseCursors        = 20
  end
  fun show_mouse_cursor = al_show_mouse_cursor(display : Display*) : LibC::Bool
  fun hide_mouse_cursor = al_hide_mouse_cursor(display : Display*) : LibC::Bool
  fun set_render_state = al_set_render_state(state : RenderState, value : LibC::Int)
  enum RenderState
    AlphaTest      = 16
    WriteMask      = 17
    DepthTest      = 18
    DepthFunction  = 19
    AlphaFunction  = 20
    AlphaTestValue = 21
  end

  struct Transform
    m : LibC::Float[4][4]
  end

  fun use_transform = al_use_transform(trans : Transform*)
  fun use_projection_transform = al_use_projection_transform(trans : Transform*)
  fun copy_transform = al_copy_transform(dest : Transform*, src : Transform*)
  fun identity_transform = al_identity_transform(trans : Transform*)
  fun build_transform = al_build_transform(trans : Transform*, x : LibC::Float, y : LibC::Float, sx : LibC::Float, sy : LibC::Float, theta : LibC::Float)
  fun build_camera_transform = al_build_camera_transform(trans : Transform*, position_x : LibC::Float, position_y : LibC::Float, position_z : LibC::Float, look_x : LibC::Float, look_y : LibC::Float, look_z : LibC::Float, up_x : LibC::Float, up_y : LibC::Float, up_z : LibC::Float)
  fun translate_transform = al_translate_transform(trans : Transform*, x : LibC::Float, y : LibC::Float)
  fun translate_transform_3d = al_translate_transform_3d(trans : Transform*, x : LibC::Float, y : LibC::Float, z : LibC::Float)
  fun rotate_transform = al_rotate_transform(trans : Transform*, theta : LibC::Float)
  fun rotate_transform_3d = al_rotate_transform_3d(trans : Transform*, x : LibC::Float, y : LibC::Float, z : LibC::Float, angle : LibC::Float)
  fun scale_transform = al_scale_transform(trans : Transform*, sx : LibC::Float, sy : LibC::Float)
  fun scale_transform_3d = al_scale_transform_3d(trans : Transform*, sx : LibC::Float, sy : LibC::Float, sz : LibC::Float)
  fun transform_coordinates = al_transform_coordinates(trans : Transform*, x : LibC::Float*, y : LibC::Float*)
  fun transform_coordinates_3d = al_transform_coordinates_3d(trans : Transform*, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*)
  fun compose_transform = al_compose_transform(trans : Transform*, other : Transform*)
  fun get_current_transform = al_get_current_transform : Transform*
  fun get_current_inverse_transform = al_get_current_inverse_transform : Transform*
  fun get_current_projection_transform = al_get_current_projection_transform : Transform*
  fun invert_transform = al_invert_transform(trans : Transform*)
  fun check_inverse = al_check_inverse(trans : Transform*, tol : LibC::Float) : LibC::Int
  fun orthographic_transform = al_orthographic_transform(trans : Transform*, left : LibC::Float, top : LibC::Float, n : LibC::Float, right : LibC::Float, bottom : LibC::Float, f : LibC::Float)
  fun perspective_transform = al_perspective_transform(trans : Transform*, left : LibC::Float, top : LibC::Float, n : LibC::Float, right : LibC::Float, bottom : LibC::Float, f : LibC::Float)
  fun horizontal_shear_transform = al_horizontal_shear_transform(trans : Transform*, theta : LibC::Float)
  fun vertical_shear_transform = al_vertical_shear_transform(trans : Transform*, theta : LibC::Float)
  fun create_shader = al_create_shader(platform : ShaderPlatform) : Shader
  enum ShaderPlatform
    ShaderAuto = 0
    ShaderGlsl = 1
    ShaderHlsl = 2
  end
  type Shader = Void*
  fun attach_shader_source = al_attach_shader_source(shader : Shader, type : ShaderType, source : LibC::Char*) : LibC::Bool
  enum ShaderType
    VertexShader = 1
    PixelShader  = 2
  end
  fun attach_shader_source_file = al_attach_shader_source_file(shader : Shader, type : ShaderType, filename : LibC::Char*) : LibC::Bool
  fun build_shader = al_build_shader(shader : Shader) : LibC::Bool
  fun get_shader_log = al_get_shader_log(shader : Shader) : LibC::Char*
  fun get_shader_platform = al_get_shader_platform(shader : Shader) : ShaderPlatform
  fun use_shader = al_use_shader(shader : Shader) : LibC::Bool
  fun destroy_shader = al_destroy_shader(shader : Shader)
  fun set_shader_sampler = al_set_shader_sampler(name : LibC::Char*, bitmap : Bitmap, unit : LibC::Int) : LibC::Bool
  fun set_shader_matrix = al_set_shader_matrix(name : LibC::Char*, matrix : Transform*) : LibC::Bool
  fun set_shader_int = al_set_shader_int(name : LibC::Char*, i : LibC::Int) : LibC::Bool
  fun set_shader_float = al_set_shader_float(name : LibC::Char*, f : LibC::Float) : LibC::Bool
  fun set_shader_int_vector = al_set_shader_int_vector(name : LibC::Char*, num_components : LibC::Int, i : LibC::Int*, num_elems : LibC::Int) : LibC::Bool
  fun set_shader_float_vector = al_set_shader_float_vector(name : LibC::Char*, num_components : LibC::Int, f : LibC::Float*, num_elems : LibC::Int) : LibC::Bool
  fun set_shader_bool = al_set_shader_bool(name : LibC::Char*, b : LibC::Bool) : LibC::Bool
  fun get_default_shader_source = al_get_default_shader_source(platform : ShaderPlatform, type : ShaderType) : LibC::Char*
  fun install_system = al_install_system(version : LibC::Int, atexit_ptr : ((-> Void) -> LibC::Int)) : LibC::Bool
  fun uninstall_system = al_uninstall_system
  fun is_system_installed = al_is_system_installed : LibC::Bool
  fun get_system_driver = al_get_system_driver : System
  type System = Void*
  fun get_system_config = al_get_system_config : Config
  ResourcesPath     = 0
  TempPath          = 1
  UserDataPath      = 2
  UserHomePath      = 3
  UserSettingsPath  = 4
  UserDocumentsPath = 5
  ExenamePath       = 6
  LastPath          = 7
  fun get_standard_path = al_get_standard_path(id : LibC::Int) : Path
  fun set_exe_name = al_set_exe_name(path : LibC::Char*)
  fun set_org_name = al_set_org_name(org_name : LibC::Char*)
  fun set_app_name = al_set_app_name(app_name : LibC::Char*)
  fun get_org_name = al_get_org_name : LibC::Char*
  fun get_app_name = al_get_app_name : LibC::Char*
  fun inhibit_screensaver = al_inhibit_screensaver(inhibit : LibC::Bool) : LibC::Bool
  fun create_thread = al_create_thread(proc : (Thread, Void* -> Void*), arg : Void*) : Thread
  type Thread = Void*
  fun start_thread = al_start_thread(outer : Thread)
  fun join_thread = al_join_thread(outer : Thread, ret_value : Void**)
  fun set_thread_should_stop = al_set_thread_should_stop(outer : Thread)
  fun get_thread_should_stop = al_get_thread_should_stop(outer : Thread) : LibC::Bool
  fun destroy_thread = al_destroy_thread(thread : Thread)
  fun run_detached_thread = al_run_detached_thread(proc : (Void* -> Void*), arg : Void*)
  fun create_mutex = al_create_mutex : Mutex
  type Mutex = Void*
  fun create_mutex_recursive = al_create_mutex_recursive : Mutex
  fun lock_mutex = al_lock_mutex(mutex : Mutex)
  fun unlock_mutex = al_unlock_mutex(mutex : Mutex)
  fun destroy_mutex = al_destroy_mutex(mutex : Mutex)
  fun create_cond = al_create_cond : Cond
  type Cond = Void*
  fun destroy_cond = al_destroy_cond(cond : Cond)
  fun wait_cond = al_wait_cond(cond : Cond, mutex : Mutex)
  fun wait_cond_until = al_wait_cond_until(cond : Cond, mutex : Mutex, timeout : Timeout*) : LibC::Int
  fun broadcast_cond = al_broadcast_cond(cond : Cond)
  fun signal_cond = al_signal_cond(cond : Cond)
  fun create_timer = al_create_timer(speed_secs : LibC::Double) : Timer*
  alias Timer = Void
  fun destroy_timer = al_destroy_timer(timer : Timer*)
  fun start_timer = al_start_timer(timer : Timer*)
  fun stop_timer = al_stop_timer(timer : Timer*)
  fun resume_timer = al_resume_timer(timer : Timer*)
  fun get_timer_started = al_get_timer_started(timer : Timer*) : LibC::Bool
  fun get_timer_speed = al_get_timer_speed(timer : Timer*) : LibC::Double
  fun set_timer_speed = al_set_timer_speed(timer : Timer*, speed_secs : LibC::Double)
  fun get_timer_count = al_get_timer_count(timer : Timer*) : Int64T
  fun set_timer_count = al_set_timer_count(timer : Timer*, count : Int64T)
  fun add_timer_count = al_add_timer_count(timer : Timer*, diff : Int64T)
  fun get_timer_event_source = al_get_timer_event_source(timer : Timer*) : EventSource*

  struct State
    _tls : LibC::Char[1024]
  end

  fun store_state = al_store_state(state : State*, flags : LibC::Int)
  fun restore_state = al_restore_state(state : State*)
  fun init_image_addon = al_init_image_addon : LibC::Bool
  fun shutdown_image_addon = al_shutdown_image_addon
  fun get_allegro_image_version = al_get_allegro_image_version : Uint32T
  NoKerning    = -1
  AlignLeft    =  0
  AlignCentre  =  1
  AlignCenter  =  1
  AlignRight   =  2
  AlignInteger =  4
  fun register_font_loader = al_register_font_loader(ext : LibC::Char*, load : (LibC::Char*, LibC::Int, LibC::Int -> Font)) : LibC::Bool
  type Font = Void*
  fun load_bitmap_font = al_load_bitmap_font(filename : LibC::Char*) : Font
  fun load_bitmap_font_flags = al_load_bitmap_font_flags(filename : LibC::Char*, flags : LibC::Int) : Font
  fun load_font = al_load_font(filename : LibC::Char*, size : LibC::Int, flags : LibC::Int) : Font
  fun grab_font_from_bitmap = al_grab_font_from_bitmap(bmp : Bitmap, n : LibC::Int, ranges : LibC::Int*) : Font
  fun create_builtin_font = al_create_builtin_font : Font
  fun draw_ustr = al_draw_ustr(font : Font, color : Color, x : LibC::Float, y : LibC::Float, flags : LibC::Int, ustr : Ustr*)
  fun draw_text = al_draw_text(font : Font, color : Color, x : LibC::Float, y : LibC::Float, flags : LibC::Int, text : LibC::Char*)
  fun draw_justified_text = al_draw_justified_text(font : Font, color : Color, x1 : LibC::Float, x2 : LibC::Float, y : LibC::Float, diff : LibC::Float, flags : LibC::Int, text : LibC::Char*)
  fun draw_justified_ustr = al_draw_justified_ustr(font : Font, color : Color, x1 : LibC::Float, x2 : LibC::Float, y : LibC::Float, diff : LibC::Float, flags : LibC::Int, text : Ustr*)
  fun draw_textf = al_draw_textf(font : Font, color : Color, x : LibC::Float, y : LibC::Float, flags : LibC::Int, format : LibC::Char*, ...)
  fun draw_justified_textf = al_draw_justified_textf(font : Font, color : Color, x1 : LibC::Float, x2 : LibC::Float, y : LibC::Float, diff : LibC::Float, flags : LibC::Int, format : LibC::Char*, ...)
  fun get_text_width = al_get_text_width(f : Font, str : LibC::Char*) : LibC::Int
  fun get_ustr_width = al_get_ustr_width(f : Font, ustr : Ustr*) : LibC::Int
  fun get_font_line_height = al_get_font_line_height(f : Font) : LibC::Int
  fun get_font_ascent = al_get_font_ascent(f : Font) : LibC::Int
  fun get_font_descent = al_get_font_descent(f : Font) : LibC::Int
  fun destroy_font = al_destroy_font(f : Font)
  fun get_ustr_dimensions = al_get_ustr_dimensions(f : Font, text : Ustr*, bbx : LibC::Int*, bby : LibC::Int*, bbw : LibC::Int*, bbh : LibC::Int*)
  fun get_text_dimensions = al_get_text_dimensions(f : Font, text : LibC::Char*, bbx : LibC::Int*, bby : LibC::Int*, bbw : LibC::Int*, bbh : LibC::Int*)
  fun init_font_addon = al_init_font_addon : LibC::Bool
  fun shutdown_font_addon = al_shutdown_font_addon
  fun get_allegro_font_version = al_get_allegro_font_version : Uint32T
  fun get_font_ranges = al_get_font_ranges(font : Font, ranges_count : LibC::Int, ranges : LibC::Int*) : LibC::Int
  fun draw_glyph = al_draw_glyph(font : Font, color : Color, x : LibC::Float, y : LibC::Float, codepoint : LibC::Int)
  fun get_glyph_width = al_get_glyph_width(f : Font, codepoint : LibC::Int) : LibC::Int
  fun get_glyph_dimensions = al_get_glyph_dimensions(f : Font, codepoint : LibC::Int, bbx : LibC::Int*, bby : LibC::Int*, bbw : LibC::Int*, bbh : LibC::Int*) : LibC::Bool
  fun get_glyph_advance = al_get_glyph_advance(f : Font, codepoint1 : LibC::Int, codepoint2 : LibC::Int) : LibC::Int
  fun draw_multiline_text = al_draw_multiline_text(font : Font, color : Color, x : LibC::Float, y : LibC::Float, max_width : LibC::Float, line_height : LibC::Float, flags : LibC::Int, text : LibC::Char*)
  fun draw_multiline_textf = al_draw_multiline_textf(font : Font, color : Color, x : LibC::Float, y : LibC::Float, max_width : LibC::Float, line_height : LibC::Float, flags : LibC::Int, format : LibC::Char*, ...)
  fun draw_multiline_ustr = al_draw_multiline_ustr(font : Font, color : Color, x : LibC::Float, y : LibC::Float, max_width : LibC::Float, line_height : LibC::Float, flags : LibC::Int, text : Ustr*)
  fun do_multiline_text = al_do_multiline_text(font : Font, max_width : LibC::Float, text : LibC::Char*, cb : (LibC::Int, LibC::Char*, LibC::Int, Void* -> LibC::Bool), extra : Void*)
  fun do_multiline_ustr = al_do_multiline_ustr(font : Font, max_width : LibC::Float, ustr : Ustr*, cb : (LibC::Int, Ustr*, Void* -> LibC::Bool), extra : Void*)
  fun set_fallback_font = al_set_fallback_font(font : Font, fallback : Font)
  fun get_fallback_font = al_get_fallback_font(font : Font) : Font

  struct MenuInfo
    caption : LibC::Char*
    id : Uint16T
    flags : LibC::Int
    icon : Bitmap
  end

  fun init_native_dialog_addon = al_init_native_dialog_addon : LibC::Bool
  fun shutdown_native_dialog_addon = al_shutdown_native_dialog_addon
  fun create_native_file_dialog = al_create_native_file_dialog(initial_path : LibC::Char*, title : LibC::Char*, patterns : LibC::Char*, mode : LibC::Int) : Filechooser
  type Filechooser = Void*
  fun show_native_file_dialog = al_show_native_file_dialog(display : Display*, dialog : Filechooser) : LibC::Bool
  fun get_native_file_dialog_count = al_get_native_file_dialog_count(dialog : Filechooser) : LibC::Int
  fun get_native_file_dialog_path = al_get_native_file_dialog_path(dialog : Filechooser, index : LibC::SizeT) : LibC::Char*
  fun destroy_native_file_dialog = al_destroy_native_file_dialog(dialog : Filechooser)
  fun show_native_message_box = al_show_native_message_box(display : Display*, title : LibC::Char*, heading : LibC::Char*, text : LibC::Char*, buttons : LibC::Char*, flags : LibC::Int) : LibC::Int
  fun open_native_text_log = al_open_native_text_log(title : LibC::Char*, flags : LibC::Int) : Textlog
  type Textlog = Void*
  fun close_native_text_log = al_close_native_text_log(textlog : Textlog)
  fun append_native_text_log = al_append_native_text_log(textlog : Textlog, format : LibC::Char*, ...)
  fun get_native_text_log_event_source = al_get_native_text_log_event_source(textlog : Textlog) : EventSource*
  fun create_menu = al_create_menu : Menu
  type Menu = Void*
  fun create_popup_menu = al_create_popup_menu : Menu
  fun build_menu = al_build_menu(info : MenuInfo*) : Menu
  fun append_menu_item = al_append_menu_item(parent : Menu, title : LibC::Char*, id : Uint16T, flags : LibC::Int, icon : Bitmap, submenu : Menu) : LibC::Int
  fun insert_menu_item = al_insert_menu_item(parent : Menu, pos : LibC::Int, title : LibC::Char*, id : Uint16T, flags : LibC::Int, icon : Bitmap, submenu : Menu) : LibC::Int
  fun remove_menu_item = al_remove_menu_item(menu : Menu, pos : LibC::Int) : LibC::Bool
  fun clone_menu = al_clone_menu(menu : Menu) : Menu
  fun clone_menu_for_popup = al_clone_menu_for_popup(menu : Menu) : Menu
  fun destroy_menu = al_destroy_menu(menu : Menu)
  fun get_menu_item_caption = al_get_menu_item_caption(menu : Menu, pos : LibC::Int) : LibC::Char*
  fun set_menu_item_caption = al_set_menu_item_caption(menu : Menu, pos : LibC::Int, caption : LibC::Char*)
  fun get_menu_item_flags = al_get_menu_item_flags(menu : Menu, pos : LibC::Int) : LibC::Int
  fun set_menu_item_flags = al_set_menu_item_flags(menu : Menu, pos : LibC::Int, flags : LibC::Int)
  fun get_menu_item_icon = al_get_menu_item_icon(menu : Menu, pos : LibC::Int) : Bitmap
  fun set_menu_item_icon = al_set_menu_item_icon(menu : Menu, pos : LibC::Int, icon : Bitmap)
  fun find_menu = al_find_menu(haystack : Menu, id : Uint16T) : Menu
  fun find_menu_item = al_find_menu_item(haystack : Menu, id : Uint16T, menu : Menu*, index : LibC::Int*) : LibC::Bool
  fun get_default_menu_event_source = al_get_default_menu_event_source : EventSource*
  fun enable_menu_event_source = al_enable_menu_event_source(menu : Menu) : EventSource*
  fun disable_menu_event_source = al_disable_menu_event_source(menu : Menu)
  fun get_display_menu = al_get_display_menu(display : Display*) : Menu
  fun set_display_menu = al_set_display_menu(display : Display*, menu : Menu) : LibC::Bool
  fun popup_menu = al_popup_menu(popup : Menu, display : Display*) : LibC::Bool
  fun remove_display_menu = al_remove_display_menu(display : Display*) : Menu
  fun get_allegro_native_dialog_version = al_get_allegro_native_dialog_version : Uint32T
  FilechooserFileMustExist =   1
  FilechooserSave          =   2
  FilechooserFolder        =   4
  FilechooserPictures      =   8
  FilechooserShowHidden    =  16
  FilechooserMultiple      =  32
  MessageboxWarn           =   1
  MessageboxError          =   2
  MessageboxOkCancel       =   4
  MessageboxYesNo          =   8
  MessageboxQuestion       =  16
  TextlogNoClose           =   1
  TextlogMonospace         =   2
  EventNativeDialogClose   = 600
  EventMenuClick           = 601
  MenuItemEnabled          =   0
  MenuItemCheckbox         =   1
  MenuItemChecked          =   2
  MenuItemDisabled         =   4
  $fixtorad_r : Fixed
  $radtofix_r : Fixed
end
