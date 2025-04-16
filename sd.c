#include <esp_vfs_fat.h>
#include <driver/sdmmc_host.h>
#include <driver/sdspi_host.h>
#include "../console/console.h"
#include "sdmmc_cmd.h"
#include "sd.h"

// #define USE_SPI_MODE

static sdmmc_card_t* card = NULL;

int sd_CardInit()
{
    // Ensure the SD card is unmounted if it's already mounted
    if (card) {
        esp_vfs_fat_sdmmc_unmount();
        card = NULL;
    }

#ifndef USE_SPI_MODE
    sdmmc_host_t host = SDMMC_HOST_DEFAULT();
    host.slot = SDMMC_HOST_SLOT_1;

    // Use 1-line SD mode
    sdmmc_slot_config_t slot_config = SDMMC_SLOT_CONFIG_DEFAULT();
    slot_config.width = 1;

    // Enable pull-ups for SD card lines
    gpio_set_pull_mode(15, GPIO_PULLUP_ONLY);   // CMD
    gpio_set_pull_mode(2, GPIO_PULLUP_ONLY);    // D0
    gpio_set_pull_mode(13, GPIO_PULLUP_ONLY);   // D3 
#else
    sdmmc_host_t host = SDSPI_HOST_DEFAULT();
    host.slot = VSPI_HOST; // HSPI_HOST
    host.max_freq_khz = 26000;

    sdspi_slot_config_t slot_config = SDSPI_SLOT_CONFIG_DEFAULT();
    slot_config.gpio_miso = 2;
    slot_config.gpio_mosi = 15;
    slot_config.gpio_sck  = 14;
    slot_config.gpio_cs   = 13;
    slot_config.dma_channel = 2;
#endif

    // Configure mounting options
    esp_vfs_fat_sdmmc_mount_config_t mount_config =
    {
        .format_if_mount_failed = false,
        .max_files = 5,
        .allocation_unit_size = 16 * 1024
    };

    // Attempt to mount SD card
    esp_err_t ret = esp_vfs_fat_sdmmc_mount("/sdcard", &host, &slot_config, &mount_config, &card);
    if (ret != ESP_OK)
    {
        card = NULL;
        if (ret == ESP_FAIL)
            console_printf(MsgError, "Failed to mount filesystem.\r\nIf you want the card to be formatted,\r\nset format_if_mount_failed = true.");
        else
            console_printf(MsgError, "Failed to initialize the card (%s).\r\nMake sure SD card lines have pull-up\r\nresistors in place.", esp_err_to_name(ret));
        return -1;
    }

    // Print SD card details
    sdmmc_card_print_info(stdout, card);
    return 0;
}


int8_t sd_GetFree(uint32_t *pFreeMb, uint32_t *pTotalMb)
{
	if (!card)
		return -1;

	FATFS *fs;
	DWORD fre_clust, fre_sect, tot_sect;

	// Get volume information and free clusters of drive 0
	int err = f_getfree("0:", &fre_clust, &fs);
	if (err)
		return -1;

	// Get total sectors and free sectors
	tot_sect = (fs->n_fatent - 2) * fs->csize;
	fre_sect = fre_clust * fs->csize;

	// Ó÷èòûâàåì ðàçìåð ñåêòîðà è ïåðåñ÷èòûâàåì â Ìá
	tot_sect /= 1024;
	tot_sect *= card->csd.sector_size;
	tot_sect /= 1024;
	fre_sect /= 1024;
	fre_sect *= card->csd.sector_size;
	fre_sect /= 1024;

	*pFreeMb = fre_sect;
	*pTotalMb = tot_sect;

	return 0;
}
