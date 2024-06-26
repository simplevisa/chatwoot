<template>
  <div v-on-clickaway="onClose" class="actions-container">
    <div class="triangle">
      <svg height="12" viewBox="0 0 24 12" width="24">
        <path d="M20 12l-8-8-12 12" fill-rule="evenodd" stroke-width="1px" />
      </svg>
    </div>
    <div class="header flex items-center justify-between">
      <span>{{ $t('BULK_ACTION.UPDATE.CHANGE_STATUS') }}</span>
      <woot-button
        size="tiny"
        variant="clear"
        color-scheme="secondary"
        icon="dismiss"
        @click="onClose"
      />
    </div>
    <div class="container">
      <woot-dropdown-menu>
        <template v-for="action in actions">
          <woot-dropdown-item v-if="showAction(action.key)" :key="action.key">
            <woot-button
              variant="clear"
              color-scheme="secondary"
              size="small"
              :icon="action.icon"
              @click="updateConversations(action.key)"
            >
              {{ actionLabel(action.key) }}
            </woot-button>
          </woot-dropdown-item>
        </template>
      </woot-dropdown-menu>
    </div>
  </div>
</template>

<script>
import WootDropdownItem from 'shared/components/ui/dropdown/DropdownItem.vue';
import WootDropdownMenu from 'shared/components/ui/dropdown/DropdownMenu.vue';

export default {
  components: {
    WootDropdownItem,
    WootDropdownMenu,
  },
  props: {
    selectedInboxes: {
      type: Array,
      default: () => [],
    },
    conversationCount: {
      type: Number,
      default: 0,
    },
    showResolve: {
      type: Boolean,
      default: true,
    },
    showReopen: {
      type: Boolean,
      default: true,
    },
    showSnooze: {
      type: Boolean,
      default: true,
    },
  },
  data() {
    return {
      query: '',
      selectedAction: null,
      actions: [
        {
          icon: 'checkmark',
          key: 'resolved',
        },
        {
          icon: 'arrow-redo',
          key: 'open',
        },
        {
          icon: 'send-clock',
          key: 'snoozed',
        },
      ],
    };
  },
  methods: {
    updateConversations(key) {
      this.$emit('update', key);
    },
    goBack() {
      this.selectedAgent = null;
    },
    onClose() {
      this.$emit('close');
    },
    showAction(key) {
      const actionsMap = {
        resolved: this.showResolve,
        open: this.showReopen,
        snoozed: this.showSnooze,
      };
      return actionsMap[key] || false;
    },
    actionLabel(key) {
      const labelsMap = {
        resolved: this.$t('CONVERSATION.HEADER.RESOLVE_ACTION'),
        open: this.$t('CONVERSATION.HEADER.REOPEN_ACTION'),
        snoozed: this.$t('BULK_ACTION.UPDATE.SNOOZE_UNTIL_NEXT_REPLY'),
      };
      return labelsMap[key] || '';
    },
  },
};
</script>

<style scoped lang="scss">
.actions-container {
  @apply absolute right-2 top-12 origin-top-right w-auto z-20 bg-white dark:bg-slate-800 rounded-lg border border-solid border-slate-50 dark:border-slate-700 shadow-md;

  .header {
    @apply p-2.5;

    span {
      @apply text-sm font-medium;
    }
  }
  .container {
    @apply px-2.5 pt-0 pb-2.5;
  }

  .triangle {
    right: var(--triangle-position);
    @apply block z-10 absolute text-left -top-3;

    svg path {
      @apply fill-white dark:fill-slate-800 stroke-slate-50 dark:stroke-slate-600/50;
    }
  }
}

ul {
  @apply m-0 list-none;
}
</style>
