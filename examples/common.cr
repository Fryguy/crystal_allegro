# Crystal port of common.c from the Allegro examples.

module Common
  def init_platform_specific
  end

  {% if env("ALLEGRO_POPUP_EXAMPLES") %}
    @@textlog : LibAllegro::Textlog?

    def textlog
      @@textlog || Pointer(Void).null.unsafe_as(LibAllegro::Textlog)
    end

    def textlog=(val)
      @@textlog = val
    end

    def abort_example(format, *args)
      str = format % args
      if LibAllegro.init_native_dialog_addon
        display = LibAllegro.is_system_installed ? LibAllegro.get_current_display : nil
        LibAllegro.show_native_message_box(display, "Error", "Cannot run example", str, nil, 0)
      else
        STDERR.print(str)
      end
      exit 1
    end

    def open_log
      if LibAllegro.init_native_dialog_addon
        self.textlog = LibAllegro.open_native_text_log("Log", 0)
      end
    end

    def open_log_monospace
      if LibAllegro.init_native_dialog_addon
        self.textlog = LibAllegro.open_native_text_log("Log", LibAllegro::TextlogMonospace)
      end
    end

    def close_log(wait_for_user)
      if textlog && wait_for_user
        queue = LibAllegro.create_event_queue
        LibAllegro.register_event_source(queue, LibAllegro.get_native_text_log_event_source(
          textlog))
        LibAllegro.wait_for_event(queue, nil)
        LibAllegro.destroy_event_queue(queue)
      end

      LibAllegro.close_native_text_log(textlog)
      self.textlog = nil
    end

    def log_printf(format, *args)
      str = format % args
      LibAllegro.append_native_text_log(textlog, str)
    end
  {% else %}
    def abort_example(format, *args)
      STDERR.printf(format, *args)
      exit 1
    end

    def open_log
    end

    def open_log_monospace
    end

    def close_log(_wait_for_user)
    end

    def log_printf(format, *args)
      printf(format, *args)
    end
  {% end %}
end
