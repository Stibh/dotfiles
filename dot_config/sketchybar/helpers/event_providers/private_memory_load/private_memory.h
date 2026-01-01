#include <mach/mach.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/sysctl.h>
#include <sys/types.h>

struct memory {
  host_t host;
  mach_msg_type_number_t count;
  vm_statistics64_data_t vm_stat;

  int total_gb;
  int used_gb;
  int used_percentage;
};

static inline void memory_init(struct memory* mem) {
  mem->host = mach_host_self();
  mem->count = HOST_VM_INFO64_COUNT;

  // Get total physical memory
  int mib[2] = {CTL_HW, HW_MEMSIZE};
  int64_t physical_memory;
  size_t length = sizeof(physical_memory);
  sysctl(mib, 2, &physical_memory, &length, NULL, 0);
  mem->total_gb = (int)(physical_memory / (1024 * 1024 * 1024));
}

static inline void memory_update(struct memory* mem) {
  kern_return_t error = host_statistics64(mem->host,
                                          HOST_VM_INFO64,
                                          (host_info64_t)&mem->vm_stat,
                                          &mem->count);

  if (error != KERN_SUCCESS) {
    printf("Error: Could not read memory host statistics.\n");
    return;
  }

  // Calculate used memory (matching Activity Monitor's "App Memory + Wired Memory")
  // Excluding inactive and speculative as they can be freed
  int64_t used_pages = mem->vm_stat.active_count
                     + mem->vm_stat.wire_count
                     + mem->vm_stat.compressor_page_count;

  int64_t total_pages = mem->vm_stat.active_count
                      + mem->vm_stat.inactive_count
                      + mem->vm_stat.wire_count
                      + mem->vm_stat.free_count
                      + mem->vm_stat.speculative_count;

  mem->used_percentage = (int)((double)used_pages / (double)total_pages * 100.0);
  mem->used_gb = (int)((double)used_pages * vm_page_size / (1024 * 1024 * 1024));
}
